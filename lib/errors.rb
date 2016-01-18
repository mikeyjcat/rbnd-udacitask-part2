module UdaciListErrors
  class InvalidItemType < StandardError
  end
  class IndexExceedsListSize < StandardError
  end
  class InvalidPriority < StandardError
  end
  class NoItems < StandardError
  end
end
