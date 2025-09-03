# Проверяет качество гипотезы прописанной в поле formulated
class CheckHypothesisQualityJob < ApplicationJob
  queue_as :default

  def perform(hypothesis_id)
    h = Hypothesis.find hypothesis_id

    chat = Chat.create provider
    # chat = RubyLLM.chat provider: ApplicationConfig.llm_provider
    chat.with_instructions "Ты эксперт в создании и развитии IT-продуктов"
  end
end
