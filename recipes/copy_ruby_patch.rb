empty_directory "tmp/build/docker/#{version}"

in_root do
  run("cp patches/#{version}/ruby.patch tmp/build/docker/#{version}")
end
