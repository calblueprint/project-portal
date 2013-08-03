class AddPhotoAttachmentToClient < ActiveRecord::Migration
  def change
    remove_column :clients, :photo
    add_attachment :clients, :photo
  end
end
