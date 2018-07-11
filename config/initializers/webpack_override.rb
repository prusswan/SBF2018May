class Webpacker::Compiler
  private
    def run_webpack
      logger.info "Compiling…with debug"

      stdout, sterr , status = Open3.capture3(webpack_env, "#{RbConfig.ruby} ./bin/webpack")

      if status.success?
        logger.info "Compiled all packs in #{config.public_output_path}"
        logger.info "sterr:\n#{sterr}\nstdout:\n#{stdout}"
      else
        logger.error "Compilation failed:\n#{sterr}\n#{stdout}"
      end

      status.success?
    end
end
