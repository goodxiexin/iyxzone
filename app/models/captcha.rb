require 'RMagick'

class Captcha < ActiveRecord::Base

  acts_as_random

  @@eligible_chars = %w(1 2 3 4 5 6 7 8 9 A B C D E F G H J K L M N P Q R S T U V X Y Z)
  
  @@default_parameters = {
    :image_width    => 120,
    :image_height   => 30,
    :code_length => 5
  }

  def public_dir
    "/images/captcha"
  end

  def format
    "png"
  end

  def image_filename
    File.join(public_dir, token + "." + format)
  end

  def self.generate params = {}
    params.delete(:dir)
    params.delete(:format)
    params.reverse_merge!(@@default_parameters)

    # use rmagic to generate image
    random_string = (1..params[:code_length].to_i).collect do
      @@eligible_chars[rand(@@eligible_chars.size)] 
    end
    img = self.generate_image random_string.join(' '), params 

    # Write the file to disk and gernate captcha_image record
    record = Captcha.create :code => random_string.join('')
    filename = File.join(RAILS_ROOT, 'public', record.image_filename)
    puts 'Writing image file ' + filename
    img.write(filename)
    
    record
  end

  before_save :generate_code

protected

  def generate_code
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join) 
  end

  def self.generate_image random_string, params
    text_img  = Magick::Image.new(params[:image_width].to_i, params[:image_height].to_i)
    black_img = Magick::Image.new(params[:image_width].to_i, params[:image_height].to_i) do
      self.background_color = 'black'
    end

    # Render the text in the image
    text_img.annotate(Magick::Draw.new, 0, 0, 0, 0, random_string) do
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

    black_img
  end

end
