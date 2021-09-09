# frozen_string_literal: true

module ApplicationHelper
  def bootstrap_devise_error_messages!
    return '' if resource.errors.empty?

    html = <<-HTML
    <div class="alert alert-danger" role="alert">
      <h4 class="alert-heading">#{sentence(resource)}</h4><ul class="mb-0">#{message(resource)}</ul>
    </div>
    HTML

    html.html_safe # rubocop:disable Rails/OutputSafety
  end

  protected

  def message(resource)
    resource.errors.full_messages.map { |message| tag.li(message) }.join
  end

  def sentence(resource)
    I18n.t(
      'errors.messages.not_saved',
      count: resource.errors.count,
      resource: resource.class.model_name.human.downcase
    )
  end
end
