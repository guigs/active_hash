require 'spec_helper'

describe ActiveYaml::Aliases do

  before do
    ActiveYaml::Base.set_root_path File.expand_path(File.dirname(__FILE__) + "/../fixtures")

    class ArrayProduct < ActiveYaml::Base
      include ActiveYaml::Aliases
    end

    class KeyProduct < ActiveYaml::Base
      include ActiveYaml::Aliases
    end
  end

  after do
    Object.send :remove_const, :ArrayProduct
    Object.send :remove_const, :KeyProduct
  end

  context 'using yaml arrays' do
    let(:model) { ArrayProduct }

    describe '.all' do
      subject { model.all }
      its(:length) { should == 4 }
    end

    describe 'aliased attributes' do
      subject { model.where(name: 'Coke').first.attributes }

      it('sets strings correctly') { subject[:flavor].should == 'sweet' }
      it('sets floats correctly') { subject[:price].should == 1.0 }
    end

    describe 'keys starting with "/"' do
      it 'excludes them' do
        models_including_aliases = model.all.select { |p| p.attributes.keys.include? :'/aliases' }
        models_including_aliases.should be_empty
      end
    end
  end

  context 'with YAML hashes' do
    let(:model) { KeyProduct }

    describe '.all' do
      subject { model.all }
      its(:length) { should == 4 }
    end

    describe 'aliased attributes' do
      subject { model.where(name: 'Coke').first.attributes }

      it('sets strings correctly') { subject[:flavor].should == 'sweet' }
      it('sets floats correctly') { subject[:price].should == 1.0 }
    end

    describe 'keys starting with "/"' do
      it 'excludes them' do
        models_including_aliases = model.all.select { |p| p.attributes.keys.include? :'/aliases' }
        models_including_aliases.should be_empty
      end
    end
  end

end
