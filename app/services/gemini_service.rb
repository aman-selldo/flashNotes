require 'httparty'
require 'json'

class GeminiService
  include HTTParty
  base_uri 'https://generativelanguage.googleapis.com/v1beta/models'

  def initialize
    @api_key = ENV['GEMINI_API_KEY'] 
  end

  def generate_questions_and_answers(paragraph)
    response = self.class.post(
      "/gemini-pro:generateContent?key=#{@api_key}",
      headers: { 'Content-Type' => 'application/json' },
      body: { contents: [{ parts: [{ text: "Generate 5 questions and answers from: #{paragraph}" }] }] }.to_json
    )

    if response.success?
      data = JSON.parse(response.body)
      return data['candidates'].first['content']['parts'].first['text'] rescue "No response from API"
    else
      return "Error: #{response.code} - #{response.body}"
    end
  end
end
