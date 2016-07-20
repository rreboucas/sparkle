public class AutoFixMentions {

    public static Set<String> getBadMentions(List<FeedItem> feedItems) {
        if (feedItems == null || feedItems.size() != 1) {
            return new Set<String>();  // Bulk feed item fixing isn't supported.
        }
        else {
            return getBadMentions(feedItems.get(0).body);
        }
    }

    public static Set<String> getBadMentions(List<FeedComment> comments) {
        if (comments == null || comments.size() != 1) {
            return new Set<String>();  // Bulk comment fixing isn't supported.
        }
        else {
            return getBadMentions(comments.get(0).commentBody);
        }
    }
        
    /**
     * Return a set of user and group names that were improperly mentioned.
     * Returns an empty set if there were no bad mentions.
     * 
     * @param body Feed item or comment body.
     */
    public static Set<String> getBadMentions(String body) {
        Set<String> badMentions = new Set<String>();

        if (body != null && body.length() > 0) {
            Pattern regex = Pattern.compile('\\@\\[.+?\\]');
            Matcher regexMatcher = regex.matcher(body);
            while (regexMatcher.find()) {
                // The group is in the form @[Firstname Lastname].
                String fullMention = regexMatcher.group(); 
                String mentionName = fullMention.substring(2, fullMention.length() - 1);
                badMentions.add(mentionName);
            }
        }

        return badMentions;
    }
    
    public static void postCommentWithMentions(List<FeedItem> feedItems, Set<String> names) {
        if (feedItems == null || feedItems.size() != 1) {
            return;  // Bulk feed item fixing isn't supported.
        }
        else {
            postCommentWithMentions(feedItems.get(0).id, names);
        }
    }

    public static void postCommentWithMentions(List<FeedComment> comments, Set<String> names) {
        if (comments == null || comments.size() != 1) {
            return;  // Bulk comment fixing isn't supported.
        }
        else {
            postCommentWithMentions(comments.get(0).feedItemId, names);
        }
    }
    
    /**
     * Posts a comment with valid @-mentions for all the users and groups in the set of
     * names that can be uniquely identified. If a name is ambiguous (e.g. if there are
     * multiple "John Smith"s in the org, that name is not mentioned.
     * 
     * @param feedItemId The parent feed item id.
     * @param names Set of user and/or group names that were improperly mentioned. 
     */
    public static void postCommentWithMentions(ID feedItemId, Set<String> names) {
    
        if (feedItemId == null || names == null || names.isEmpty()) {
            return;
        }
        
        String communityId = Network.getNetworkId();
        Set<ID> idsToMention = new Set<ID>();
        Map<String, ID> namesToMention = new Map<String, ID>();
        
        // For performance reasons, it's best to only make one database call.
        // Retrieve all of the mentioned users, and then filter out those that aren't unique.
        
        List<User> users = [SELECT id, name FROM User WHERE Name IN :names AND isActive = true];
        for (User u : users) {
            if (namesToMention.containsKey(u.name)) {
                // The name cannot be uniquely identified. Don't try to mention it.
                // Remove the id of the previous match for this name.
                idsToMention.remove(namesToMention.get(u.name));
            }
            else {
                namesToMention.put(u.name, u.id);
                idsToMention.add(u.id);
                names.remove(u.name);
            }
        }

        if (!names.isEmpty()) {
            // Maybe a group mention was intended. Try to find groups that match the names.
            List<CollaborationGroup> groups = [SELECT id FROM CollaborationGroup WHERE Name IN :names AND isArchived = false AND CanHaveGuests = false];
            for (CollaborationGroup g : groups) {
                // Groups can't have the same name, so a definitive match has been found.
                idsToMention.add(g.id);
            }
        }
        
        if (idsToMention.size() > 0) {
            // Post a comment with the mentions.
            ConnectApi.CommentInput input = new ConnectApi.CommentInput();
            input.body = new ConnectApi.MessageBodyInput();
            input.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            
            for (ID idToMention : idsToMention) {
                ConnectApi.MentionSegmentInput mentionInput = new ConnectApi.MentionSegmentInput();
                mentionInput.id = idToMention;
                input.body.messageSegments.add(mentionInput);
                
                ConnectApi.TextSegmentInput textInput = new ConnectApi.TextSegmentInput();
                textInput.text = ' ';
                input.body.messageSegments.add(textInput);
            }
            
            ConnectApi.ChatterFeeds.postComment(communityId, feedItemId, input, null);
        }
    
    }
    
}