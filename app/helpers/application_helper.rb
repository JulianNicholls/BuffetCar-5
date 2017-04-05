module ApplicationHelper
  def gravatar_for chef, options = { size: 80, default: 'retro' }
    gravatar_id = Digest::MD5.hexdigest chef.email.downcase
    size    = options[:size]
    default = options[:default]

    gravatar_url = "https://gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=#{default}"
    image_tag gravatar_url, alt: chef.name, class: 'img-circle'
  end
end
