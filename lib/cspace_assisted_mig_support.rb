# frozen_string_literal: true

require "kiba/extend"

# Namespace for the overall project
module CspaceAssistedMigSupport
  ::Cams = CspaceAssistedMigSupport

  module_function

  # @return Zeitwerk::Loader
  def loader
    @loader ||= setup_loader
  end

  private def setup_loader
    @loader = Zeitwerk::Loader.for_gem
    @loader.enable_reloading
    @loader.setup
    @loader.eager_load
    @loader
  end

  def reload!
    @loader.reload
  end

  extend Dry::Configurable
  setting :datadir, default: File.expand_path("data"), reader: true

  setting :derived_dirs,
    default: %w[for_import working],
    reader: true,
    constructor: proc { |value| value.map { |dir| File.join(datadir, dir) } }
  Kiba::Extend.config.pre_job_task_run = true
  Kiba::Extend.config.pre_job_task_directories = derived_dirs
  Kiba::Extend.config.pre_job_task_action = :nuke
  Kiba::Extend.config.pre_job_task_mode = :job

  # @return [String] source file name. File must be in data/supplied directory
  setting :authority_extract_source_file,
    default: "authority_orig.csv",
    reader: true
  # @return [Array<Symbol>] headers of columns from which to extract authority
  #   values
  setting :authority_extract_headers,
    default: %i[main_subject assoc_subject],
    reader: true
  # @return [Array<String>] delimiters (in addition to Cams.delim) to split
  #   authority values on
  setting :authority_split_delims,
    default: ["; ", ";", "\n"],
    reader: true

  # **This is the only Kiba::Extend setting that is required to be namespaced
  #   in your project.** Do not remove or change the `:registry` setting, or
  #   Thor task running will break.
  setting :registry, default: Kiba::Extend.registry, reader: true

  # Doing the following just lets us write
  #   `CspaceAssistedMigSupport.delim` in our project specific code,
  #   instead of `Kiba::Extend.delim`, while ensuring a consistent
  #   default :delim is used across the board.
  setting :delim, default: Kiba::Extend.delim, reader: true
end

CspaceAssistedMigSupport.loader

CspaceAssistedMigSupport::RegistryData.register
