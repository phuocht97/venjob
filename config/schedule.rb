env :PATH, ENV['PATH']
every 5.minutes do
  rake 'import:auto'
end

