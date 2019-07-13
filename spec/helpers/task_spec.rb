require 'rails_helper'
include TasksHelper

RSpec.describe Task, type: :helper do
  describe 'flash_message' do
    context 'when param is "notice"' do
      let(:flash_notice) { %Q(<p class="flash_notice">notice message</p>).html_safe }
      let(:flash_alert) { %Q(<p class="flash_alert">alert message</p>).html_safe }
      
      it 'should generate a notice html tag' do
        allow_any_instance_of(ActionDispatch::Flash::FlashHash).to receive(:[]).with(:notice).and_return('notice message')
        expect(flash_message(:notice)).to eq flash_notice
      end

      it 'should generate an alert html tag' do
        allow_any_instance_of(ActionDispatch::Flash::FlashHash).to receive(:[]).with(:alert).and_return('alert message')
        expect(flash_message(:alert)).to eq flash_alert
      end

    end
  end

  describe 'delete_link_to' do
    let(:result_link) {
      %Q(<a data-confirm="#{I18n.t("are_you_sure")}" rel="nofollow" data-method="delete" href="some_path">some_label</a>)
    }
    it 'should return a delete_link_to' do
      expect(delete_link_to('some_label', 'some_path')).to eq result_link
    end
  end

  describe 'sort_link' do
    context 'when ordering tasks by "created_at"' do
      let(:default_link) { "<a href=\"/?created_at=desc\">some_label</a>" }
      let(:asc_link) { "<a class=\"sort_link asc\" href=\"/?created_at=desc\">some_label</a>" }
      let(:desc_link) { "<a class=\"sort_link desc\" href=\"/?created_at=asc\">some_label</a>" }

      it 'should show default link when there is no params[:created_at]' do
        expect(sort_link_to('some_label', 'tasks', "created_at")).to eq(default_link)
      end

      it 'should show asc link when params[:created_at] == "asc"' do
        controller.params[:created_at] = "asc"
        expect(sort_link_to('some_label', 'tasks', "created_at")).to eq(asc_link)
      end
      
      it 'should show desc link when params[:created_at] == "desc"' do
        controller.params[:created_at] = "desc"
        expect(sort_link_to('some_label', 'tasks', "created_at")).to eq(desc_link)
      end
    end
  end
end