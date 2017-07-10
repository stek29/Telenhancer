%group FixExplicit

%hook TGUser
- (bool)hasExplicitContent {
  return false;
}
%end

%hook TGConversation
- (bool)hasExplicitContent {
  return false;
}
%end

%end

%ctor {
  %init(FixExplicit);
}
