timer.Create( "Autodecal", 300, 0, function()
	RunConsoleCommand("ulx", "stopsounds")
	RunConsoleCommand("ulx", "cleardecals")
	RunConsoleCommand("ulx", "nolag")
end)