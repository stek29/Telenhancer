%group NeverExplicit

#define fix(CLS)\
  %hook CLS\
    - (bool)hasExplicitContent {\
      return false;\
  }\
  %end

fix(TGUser);
fix(TGConversation);

%end
