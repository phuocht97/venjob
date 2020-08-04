env :PATH, ENV['PATH']
every 20.minutes do
  rake 'import:auto'
end

