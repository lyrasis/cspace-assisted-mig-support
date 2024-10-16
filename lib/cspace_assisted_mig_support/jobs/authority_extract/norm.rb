# frozen_string_literal: true

module CspaceAssistedMigSupport
  module Jobs
    module AuthorityExtract
      module Norm
        module_function

        def job
          Kiba::Extend::Jobs::Job.new(
            files: {
              source: :authority_extract__split,
              destination: :authority_extract__norm
            },
            transformer: xforms
          )
        end

        def xforms
          Kiba.job_segment do
            transform Delete::FieldsExcept,
              fields: :value
            transform Rename::Field,
              from: :value,
              to: :orig
            transform Cspace::NormalizeForID,
              source: :orig,
              target: :norm
            transform Replace::NormWithMostFrequentlyUsedForm,
              normfield: :norm,
              nonnormfield: :orig,
              target: :usedform
            transform Delete::Fields,
              fields: :norm
            transform CombineValues::FullRecord,
              prepend_source_field_name: false,
              delim: "||",
              delete_sources: false
            transform Deduplicate::Table,
              field: :index,
              delete_field: true
          end
        end
      end
    end
  end
end
