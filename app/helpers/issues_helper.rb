module IssuesHelper
	def printTags(issue)
		tags = Tag.where("issue_id = ?", issue.id)
		allTags = ""
		tags.each  do |tag|
			allTags = allTags + ", #" +tag.label
		end
		if allTags.length == 0
			allTags = "None"
		else
			allTags = allTags[2..allTags.length]
		end
		return allTags
	end
end
