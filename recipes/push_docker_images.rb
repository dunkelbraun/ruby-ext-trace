inside "tmp/build/docker/#{version}" do
  if distro == "all"
    distros = %w[alpine3.16 alpine3.17 bullseye buster slim-bullseye slim-buster]
    distros.each do |_dockerfile|
      tag = [version, dstro].join("-")
      run "docker push test_docker_ruby:#{tag}"
    end
  else
    tag = [version, distro].join("-")
    run "docker push #{ENV.fetch('DOCKER_REPO')}:#{tag}"
  end
end
