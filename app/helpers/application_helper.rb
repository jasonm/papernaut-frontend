module ApplicationHelper
  def identifiers_for(identifiable)
    if identifiable.identifier_strings.any?
      "(" + identifiable.identifier_strings.join(" | ") + ")"
    else
      ""
    end
  end

  def source_sentence(user)
    sources = user.articles.select(:source).map(&:source).uniq
    sources << "empty" if sources.empty?

    sources.map(&:capitalize).to_sentence
  end
end
