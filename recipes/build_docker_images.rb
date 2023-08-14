inside "tmp/build/docker/#{version}" do
  if distro == "all"
    dockerfiles = Dir.glob("*.Dockerfile")
    dockerfiles.each do |dockerfile|
      tag = [version, File.basename(dockerfile, ".Dockerfile")].join("-")
      run "docker build -t test_docker_ruby:#{tag} -f #{dockerfile} ."
    end
  else
    dockerfile = "#{distro}.Dockerfile"
    tag = [version, distro].join("-")
    run "docker build -t #{ENV.fetch('DOCKER_REPO')}:#{tag} -f #{dockerfile} ."
  end
end
