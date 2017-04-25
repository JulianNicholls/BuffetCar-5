module ApplicationHelper
  GRAVATAR_BASE_URL = 'https://gravatar.com/avatar/'.freeze

  def gravatar_for chef, options = { size: 80, default: 'retro' }
    gravatar_id = Digest::MD5.hexdigest chef.email.downcase
    size    = options[:size]
    default = options[:default]

    gravatar_url = "#{GRAVATAR_BASE_URL}#{gravatar_id}?s=#{size}&d=#{default}"
    image_tag gravatar_url, alt: chef.name, class: 'img-circle'
  end
end
