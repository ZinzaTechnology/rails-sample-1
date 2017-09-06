require 'rqrcode'

module QrUtil
  def generate_qr(uri)
    base_url = ENV['DOMAIN']
    qrcode = RQRCode::QRCode.new(base_url + uri)
    path = "tmp/#{SecureRandom.uuid}.png"
    qrcode.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 180,
      border_modules: 4,
      module_px_size: 6,
      file: path
    )
    path
  end
end
