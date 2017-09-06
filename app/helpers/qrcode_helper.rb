# frozen_string_literal: true

module QrcodeHelper
  require 'rqrcode'

  def render_qr_code(text, size = 3)
    return if text.to_s.empty?

    qr = RQRCode::QRCode.new(text)
    style = "width: #{size}px; height: #{size}px;"

    content_tag(:table, class: 'qrcode') do
      qr.modules.each_index do |x|
        concat(
          content_tag(:tr) do
            qr.modules.each_index do |y|
              color = qr.dark?(x, y) ? 'black' : 'white'
              concat content_tag(:td, nil, class: color, style: style)
            end
          end,
        )
      end
    end
  end

  def render_qr_code_as_image(text, size = 3)
    return if text.to_s.empty?

    RQRCode::QRCode.new(text).to_img.resize(40 * size, 40 * size).to_data_url
  end
end
