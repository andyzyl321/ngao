
class MyApplicationViewer
  def initialize(document)
    @document = document
  end

  def to_partial_path
    'viewers/_my_viewer'
  end

  def images
    @document.fetch(:image_urls_ssim, [])
  end
end
