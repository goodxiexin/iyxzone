require 'RMagick' 

module Captcha

  module ImageGenerator

    @@eligible_chars = %w(1 2 3 4 5 6 7 8 9 A B C D E F G H J K L M N P Q R S T U V X Y Z)
  
    @@default_parameters = {
      :image_width    => 120,
      :image_height   => 30,
      :code_length => 5,
      :directory => "public/images/captcha"
    }

    def self.generate params = {}
      params.reverse_merge!(@@default_parameters)

      text_img  = Magick::Image.new(params[:image_width].to_i, params[:image_height].to_i)
      black_img = Magick::Image.new(params[:image_width].to_i, params[:image_height].to_i) do
        self.background_color = 'black'
      end

      # Generate a 5 character random string
      random_string = (1..params[:code_length].to_i).collect do
        @@eligible_chars[rand(@@eligible_chars.size)] 
      end

      # Render the text in the image
      text_img.annotate(Magick::Draw.new, 0, 0, 0, 0, random_string.join(' ')) do
        self.gravity = Magick::WestGravity
        self.font_family = 'Thonburi'
        self.fill = '#666666'
        self.stroke = 'black'
        self.stroke_width = 2
        self.pointsize = 25
      end

      # Apply a little blur and fuzzing
      text_img = text_img.gaussian_blur(1.2, 1.2)
      text_img = text_img.sketch(20, 30.0, 30.0)
      text_img = text_img.wave(3, 150)

      # Now we need to get the white out
      text_mask = text_img.negate
      text_mask.matte = false

      # Add cut-out our captcha from the black image with varying tranparency
      black_img.composite!(text_mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)

      # Write the file to disk and gernate captcha_image record
      record = CaptchaImage.create :code => random_string
      filename = record.public_filename
      puts 'Writing image file ' + filename
      black_img.write(filename)
    end

  end

end  
