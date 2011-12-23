require 'FileUtils'

print 'Minimize (y/n) '
minimize = /^(y|yes|1)$/.match(readline) ? true : false

if File.exists?('tpl/_head_script.html')
	FileUtils.rm('tpl/_head_script.html')
end
	
if minimize
	scripts = Dir.glob('js/*.js')
	scripts = scripts.map { |s| "--js " + s }
	
	cmdLine = 'java -jar tools/closure-compiler.jar --js_output_file minimized.js ' + scripts.join(' ')
	puts cmdLine
	
	system(cmdLine)
	
	minimizedScripts = ['../default/js/jquery.js', '../default/js/jquery.cookie.js']
	minimizedScripts.concat(Dir.glob('js/minimized/*.js'))
	
	open('minimized.js', 'a') { |file|
		minimizedScripts.each { |otherFile|
			open(otherFile).each { |line|
				file.puts line
			}
		}
	}
	
	FileUtils.cp('tpl/_head_script_minimized.html', 'tpl/_head_script.html');
else
	FileUtils.cp('tpl/_head_script_full.html', 'tpl/_head_script.html');
end