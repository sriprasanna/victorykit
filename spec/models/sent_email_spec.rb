require 'spec_helper'

describe SentEmail do
  describe "analytics" do
    it "should increment unsubscribe count on create" do
      expect { create(:sent_email) }.to change{ $statsd.value_of("emails_sent") }.from(0).to(1)
    end
  end

  describe "#track_visit!" do
    subject { build(:sent_email) }

    it "should record the time of the visit" do
      expect { subject.track_visit! }.to change{ subject.clicked_at }.from(nil)
    end

    it "should increment emails_clicked" do
      expect { subject.track_visit! }.to change{ $statsd.value_of("emails_clicked") }.from(0).to(1)
    end
  end
end