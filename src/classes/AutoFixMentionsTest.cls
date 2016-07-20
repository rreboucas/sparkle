@IsTest(SeeAllData=true)
public class AutoFixMentionsTest {

    @IsTest(SeeAllData=true)
    static void testGetBadMentionsFeedItem() {
    
        // Unit test for AutoFixMentions.getBadMentions(). Does not query DB.
    
        String username1 = 'Milhouse van Housen';
        String username2 = 'Abe Simpson';
    
        FeedItem fi = new FeedItem();
        fi.Body = 'Try this: @[' + username1 + '] @[' + username2 + '] @[' + username1 + ']';
        fi.Type = 'TextPost';
        fi.ParentId = UserInfo.getUserId();
        insert fi;
        
        List<FeedItem> feedItems = new List<FeedItem>();
        feedItems.add(fi);
        
        Set<String> expected = new Set<String>();
        expected.add(username1);
        expected.add(username2);
        
        Set<String> actual = AutoFixMentions.getBadMentions(feedItems);
        
        System.assertEquals(expected, actual);
    }

    @IsTest(SeeAllData=true)
    static void testGetBadMentionsNullComments() {
        Set<String> expected = new Set<String>();
        List<FeedComment> comments = null;
        Set<String> actual = AutoFixMentions.getBadMentions(comments);
        System.assertEquals(expected, actual);
    }
    
    @IsTest(SeeAllData=true)
    static void testPostCommentWithMentions() {
    
        User[] users = [SELECT name, id FROM user WHERE isActive = true LIMIT 1];
        ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.News, 'me', 'Parent feed item');
    
        Set<String> names = new Set<String>();
        names.add(users[0].name);
        names.add('a fake name that does not exist @#$%$afdjfadks');
        AutoFixMentions.postCommentWithMentions(fi.id, names);
        
        ConnectApi.CommentPage commentPage = ConnectApi.ChatterFeeds.getCommentsForFeedItem(null, fi.id);
        
        User[] userCheck = [SELECT name, id FROM user WHERE isActive = true AND name = :users[0].name];
        if (userCheck.size() == 1) {
            System.assertEquals(1, commentPage.comments.size(), 'Unexpected number of comments.');
            ConnectApi.FeedBody commentBody = commentPage.comments.get(0).body;
            System.assertEquals(1, commentBody.messageSegments.size(), 'Unexpected number of message segments.');
            System.assert(commentBody.messageSegments.get(0) instanceof ConnectApi.MentionSegment, 'Message segment was not a mention segment.');
            ConnectApi.MentionSegment segment = (ConnectApi.MentionSegment) commentBody.messageSegments.get(0);
            System.assertEquals(users[0].id, segment.record.id, 'Unexpected record id in mention segment.');
        }
        else {
            // The user's name is not unique, so there shouldn't be any corrections.
            System.assertEquals(0, commentPage.comments.size(), 'Unexpected number of comments.');
        }
    
    }
    
}