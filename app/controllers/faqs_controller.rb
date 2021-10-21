class FaqsController < ApplicationController
  def index
    @faqs = Faq.all
    @faq_types = Faq.select(:faqtype).distinct
  end
end
