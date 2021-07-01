# frozen_string_literal: true

ActiveAdmin.register Integration do
  permit_params :tenant_id

  action_item :view, only: :index do
    link_to 'Add Xero Integration', '/auth/xero_oauth2', method: :post
  end

  index do
    id_column
    column :type
    column :created_at
    actions
  end

  form do |f|
    f.inputs 'Integration Details' do
      f.input :tenant_id, as: :select, collection: integration.client.current_connections.map { |t|
                                                     [t.tenant_name, t.tenant_id]
                                                   }
    end
    f.actions
  end
end
