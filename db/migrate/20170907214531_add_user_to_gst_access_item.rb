class AddUserToGstAccessItem < ActiveRecord::Migration[5.0]
  def up
    add_column :gst_access_items, :user, :integer
    GstAccessItem.reset_column_information
    GstAccessItem.all.each do |gst_access_item|      
      if gst_access_item.domain.present? && gst_access_item.user_email.present?
        domain = Domain.where(name: gst_access_item.domain).first
        if domain.present?
          domain_id = domain.id
        end
        user = User.where(domain_id: domain_id, email: gst_access_item.user_email).first
        if user.present?
          gst_access_item.update(user: user.id)
        end
      end
    end
  end
  
  def down
    remove_column :gst_access_items, :user
  end
end
