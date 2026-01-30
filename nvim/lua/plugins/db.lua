-- Database Plugins
-- DB 관련 플러그인
return {
  --[[
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_win_position = "right"
			vim.g.db_ui_use_nvim_notify = 1
			vim.g.db_ui_quote_table_names = 1
			vim.g.db_ui_auto_execute_table_helpers = 1

			local function get_free_port()
				local server = vim.loop.new_tcp()
				server:bind("127.0.0.1", 0) -- 0번 포트로 바인딩하면 OS가 남는 포트 할당
				local port = server:getsockname().port
				server:close()
				return port
			end

			local function unlock_gpg()
				-- Snacks가 있다면 예쁜 플로팅 터미널로, 없다면 일반 터미널로 띄움
				if _G.Snacks then
					Snacks.terminal("gopass ls", {
						win = { style = "float", border = "rounded", title = "GPG Unlock" },
						interactive = true,
						height = 0.3,
						width = 0.6,
					})
				else
					vim.cmd("split | terminal gopass ls")
				end
			end

			local function get_pass(path)
				local cmd = "gopass show -o " .. path
				local password = vim.fn.system(cmd)
				if vim.v.shell_error ~= 0 then
					vim.schedule(function()
						vim.notify(
							"🔒 GPG Locked! Press <Leader>gu to unlock.\nPath: " .. path,
							vim.log.levels.WARN,
							{ title = "Dadbod Auth Failed" }
						)
					end)
					return ""
				end
				return vim.fn.trim(password)
			end
			vim.keymap.set("n", "<leader>gu", unlock_gpg, { desc = "Unlock GPG (Gopass)" })
      vim.keymap.set("n","<leader>dut", "<CMD>DBUIToggle<CR>",{ desc = "Toggle DB UI"})

			local ssm_jobs = {}
			local function start_ssm_tunnel(region, instance_id, remote_host, remote_port)
				local local_port = get_free_port()
				region = region or "ap-northeast-2"

				-- [중요] --region 옵션 추가
				local cmd = string.format(
					'aws ssm start-session --region %s --target %s --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters \'{"host":["%s"],"portNumber":["%s"],"localPortNumber":["%s"]}\'',
					region,
					instance_id,
					remote_host,
					remote_port,
					local_port
				)

				local job_id = vim.fn.jobstart(cmd, {
					-- 프로세스가 비정상 종료되었을 때
					on_exit = function(_, code)
						if code ~= 0 and code ~= 130 and code ~= 143 then
							vim.schedule(function()
								vim.notify(
									string.format("SSM Tunnel exited (Port: %s). Code: %d", local_port, code),
									vim.log.levels.WARN
								)
							end)
						end
					end,
					-- [추가] 왜 실패했는지 AWS 에러 메시지를 출력 (Stderr 캡처)
					on_stderr = function(_, data)
						if data then
							local msg = table.concat(data, "\n")
							if msg ~= "" and string.find(msg, "error") then -- 단순 로그가 아니라 에러일 때만 표시
								vim.schedule(function()
									vim.notify("SSM Error: " .. msg, vim.log.levels.ERROR)
								end)
							end
						end
					end,
				})

				if job_id > 0 then
					table.insert(ssm_jobs, job_id)
					vim.loop.sleep(500)
				end

				return local_port
			end

			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					for _, job_id in ipairs(ssm_jobs) do
						vim.fn.jobstop(job_id)
					end
				end,
			})

			vim.g.dbs = {
				{
					name = "Dev Cordoba (Via SSM)",
					url = function()
						local port = start_ssm_tunnel(
							"ap-northeast-2",
							"i-01b5f72c907d157bd", -- kube-system
							"cordoba-db-20250610023056693800000002.cdemayem04dt.ap-northeast-2.rds.amazonaws.com",
							"3306"
						)
						local pass = get_pass("dev/cordoba/db/admin")
						return string.format("mysql://admin:%s@127.0.0.1:%s/cordoba", pass, port)
					end,
				},
				{
					name = "Dev Freetier (Via SSM)",
					url = function()
						local port = start_ssm_tunnel(
							"ap-northeast-2",
							"i-01b5f72c907d157bd", -- kube-system
							"rds-free-001-2025052910193070160000001b.cdemayem04dt.ap-northeast-2.rds.amazonaws.com",
							"3306"
						)
						local pass = get_pass("dev/miri/db/miri")
						return string.format("mysql://miri:%s@127.0.0.1:%s/", pass, port)
					end,
				},
				{
					name = "Prod Cordoba (Via SSM)",
					url = function()
						local port = start_ssm_tunnel(
							"us-east-1",
							"i-01b460ec90701a55c", -- kube-system
							"cordoba-db-20250610023100131600000002.c7y00mm6e5yq.us-east-1.rds.amazonaws.com",
							"3306"
						)
						local pass = get_pass("prod/cordoba/db/admin")
						return string.format("mysql://admin:%s@127.0.0.1:%s/cordoba", pass, port)
					end,
				},
				{
					name = "Prod free-001 (Via SSM)",
					url = function()
						local port = start_ssm_tunnel(
							"us-east-1",
							"i-01b460ec90701a55c", -- kube-system
							"rds-free-001-20250428063311918200000005.c7y00mm6e5yq.us-east-1.rds.amazonaws.com",
							"3306"
						)
						local pass = get_pass("prod/miri/db/miri@us-east-1.free-001")
						return string.format("mysql://miri:%s@127.0.0.1:%s/", pass, port)
					end,
				},
				{
					name = "Prod std-001 (Via SSM)",
					url = function()
						local port = start_ssm_tunnel(
							"us-east-1",
							"i-01b460ec90701a55c", -- kube-system
							"rds-std-001-20250526101653152000000007.c7y00mm6e5yq.us-east-1.rds.amazonaws.com",
							"3306"
						)
						local pass = get_pass("prod/miri/db/miri@us-east-1.std-001")
						return string.format("mysql://miri:%s@127.0.0.1:%s/", pass, port)
					end,
				},
			}

			vim.g.Db_ui_buffer_name_generator = function(opts)
				if not opts.table or opts.table == "" then
					return opts.schema .. "query.sql"
				end
				return opts.schema .. opts.table .. "-" .. opts.label .. ".sql"
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					-- 타이밍 문제를 방지하기 위해 vim.schedule 사용
					vim.schedule(function()
						-- 현재 버퍼가 수정 가능한 상태인지 확인
						if not vim.api.nvim_buf_is_valid(0) then
							return
						end

						local buf_name = vim.api.nvim_buf_get_name(0)
						if not (string.find(buf_name, "/var/folders/") and string.find(buf_name, "/T/nvim")) then
							return
						end

						local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
						local new_lines = {}
						local changed = false

						for _, line in ipairs(lines) do
							-- [정규식 설명]
							-- FROM%s+         : "FROM "
							-- ([%w%-]+)       : 그룹1 (UUID) - 알파벳, 숫자, 하이픈(-)
							-- %.              : 점 (.)
							-- ([%w%_]+)       : 그룹2 (테이블명) - 알파벳, 숫자, 언더바(_)
							--
							-- 이 패턴을 찾아서 -> FROM `그룹1`.`그룹2` 로 바꿈
							local new_line = string.gsub(line, "FROM%s+([%w%-]+)%.([%w%_]+)", "FROM `%1`.`%2`")
							table.insert(new_lines, new_line)
							if new_line ~= line then
								changed = true
							end
						end

						-- 변경사항이 있으면 버퍼에 덮어씌움
						if changed then
							vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
							vim.bo.modified = true -- '수정됨' 표시 제거
						end
					end)
				end,
			})

			vim.g.db_ui_table_helpers = {
				mysql = {
					List = "SELECT * FROM {optional_schema}{table} ORDER BY id desc LIMIT 200",
					Count = "select count(*) from {optional_schema}{table}",
				},
			}

			vim.g.completion_chain_complete_list = {
				sql = {
					{ complete_items = { "vim-dadbod-completion" } },
				},
			}
			vim.g.completion_matching_strategy_list = { "exact", "substring" }
			vim.g.completion_matching_ignore_case = 1
		end,
	},
  ]]--
}
