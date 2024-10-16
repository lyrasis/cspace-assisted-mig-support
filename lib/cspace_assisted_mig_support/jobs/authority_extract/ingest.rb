# frozen_string_literal: true

module CspaceAssistedMigSupport
  module Jobs
    module AuthorityExtract
      module Ingest
        module_function

        def job
          Kiba::Extend::Jobs::Job.new(
            files: {
              source: :authority_extract__norm,
              destination: :authority_extract__ingest
            },
            transformer: xforms
          )
        end

        def xforms
          Kiba.job_segment do
            transform Delete::FieldsExcept,
              fields: :usedform
            transform Deduplicate::Table,
              field: :usedform,
              delete_field: false
            transform Rename::Field,
              from: :usedform,
              to: :termdisplayname
          end
        end
      end
    end
  end
end
