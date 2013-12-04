require_relative '../spec_helper'

describe Face do
  let(:avatar_path) { './test/fixtures/avatar.jpg' }

  it 'writes an annotated image' do
    @face = Face.new(avatar_path)

    file = @face.write_annotated_image!

    actual_md5 = Digest::MD5.hexdigest(File.read(file))
    expected_md5 = Digest::MD5.hexdigest(File.read(avatar_path))
  end

  it 'should have the same descriptors for the same faces' do
    @face = Face.new(avatar_path)
    @face2 = Face.new(avatar_path)

    @face.descriptors.must_equal @face2.descriptors
  end

  it 'should have the same keypoints for the same face' do
    @face = Face.new(avatar_path)
    @face2 = Face.new(avatar_path)

    # This is purely because Ruby's implementation of OpenCV doesn't
    # Have a representation of == for SurfPoints :(
    @face.keypoints.each_with_index do |kp, i|
      kp.pt.x.must_equal @face2.keypoints[i].pt.x
      kp.pt.y.must_equal @face2.keypoints[i].pt.y
    end
  end
end