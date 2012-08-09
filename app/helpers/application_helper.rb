module ApplicationHelper
  def identifiers_for(identifiable)
    if identifiable.identifier_strings.any?
      "(" + identifiable.identifier_strings.join(" | ") + ")"
    else
      ""
    end
  end
end
