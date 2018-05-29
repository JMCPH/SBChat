https://stackoverflow.com/questions/33540479/best-way-to-manage-chat-channels-in-firebase 


A common way to handle such 1:1 chat rooms is to generate the room URL based on the user ids. As you already mention, a problem with this is that either user can initiate the chat and in both cases they should end up in the same room.

You can solve this by ordering the user ids lexicographically in the compound key. For example with user names, instead of ids:


var user1 = "Frank";
var user2 = "Eusthace";

var roomName = 'chat_'+(user1<user2 ? user1+'_'+user2 : user2+'_'+user1);

console.log(user1+', '+user2+' => '+ roomName);

user1 = "Eusthace";
user2 = "Frank";

var roomName = 'chat_'+(user1<user2 ? user1+'_'+user2 : user2+'_'+user1);

console.log(user1+', '+user2+' => '+ roomName);

