class FileUploadQuestion < ApplicationRecord
    has_one_attached:upload_file, dependent: :destroy

end
