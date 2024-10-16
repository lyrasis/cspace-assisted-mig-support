# frozen_string_literal: true

module CspaceAssistedMigSupport
  module RegistryData
    module_function

    def register
      register_files
      Cams.registry.finalize
    end

    def register_files
      Cams.registry.namespace("authority_extract") do
        register :orig, {
          path: File.join(Cams.datadir, "supplied",
                          Cams.authority_extract_source_file),
          supplied: true,
          desc: "Client-supplied source data file"
        }
        register :extract, {
          path: File.join(Cams.datadir, "working",
            "authority_extract.csv"),
          creator: Cams::Jobs::AuthorityExtract::Extract,
          desc: "Extract all authority values, with source column name, to "\
            ":value and :source fields"
        }
        register :split, {
          path: File.join(Cams.datadir, "working",
                          "authority_split.csv"),
          creator: Cams::Jobs::AuthorityExtract::Split,
          desc: "Split extracted authority values"
        }
        register :norm, {
          path: File.join(Cams.datadir, "working", "authority_norm.csv"),
          creator: Cams::Jobs::AuthorityExtract::Norm,
          desc: "Set :usedform based matching normalized forms, choosing the "\
            "most frequently occurring original form",
          lookup_on: :orig
        }
        register :split_clean, {
          creator: Cams::Jobs::AuthorityExtract::SplitClean,
          path: File.join(Cams.datadir, "working",
                          "authority_split_clean.csv"),
          desc: "Provides used form of term for each split value",
          lookup_on: :full_value
        }
        register :extract_clean, {
          creator: Cams::Jobs::AuthorityExtract::ExtractClean,
          path: File.join(Cams.datadir, "working",
                          "authority_extract_clean.csv"),
          desc: "Reconstitutes multivalued strings to merge back into orig "\
            "data. Also serves as source for manual find/replace todo list",
          lookup_on: :value
        }
        register :ingest, {
          path: File.join(Cams.datadir, "output", "authority_load.csv"),
          creator: Cams::Jobs::AuthorityExtract::Ingest,
          desc: "Unique :usedform values for ingest",
          tags: %i[output]
        }
        register :todo, {
          path: File.join(Cams.datadir, "output", "authority_cleanup_todo.csv"),
          creator: Cams::Jobs::AuthorityExtract::Todo,
          desc: "Manual find/replace todo list",
          tags: %i[output]
        }
        register :cleaned_source, {
          path: File.join(Cams.datadir, "output",
                          "authority_cleaned_source.csv"),
          creator: Cams::Jobs::AuthorityExtract::CleanedSource,
          desc: "Adds 'cleaned' columns to source data, merging in loaded "\
            "forms of authority terms",
          tags: %i[output]
        }
      end
    end
    private_class_method :register_files
  end
end
