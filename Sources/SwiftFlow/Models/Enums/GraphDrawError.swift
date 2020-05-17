import Foundation

public enum GraphDrawError: Error {
  case graphIsEmpty
  case nodeIdDuplicate
  case nodeStartNotFound
  case nodeDangling
  case nodeShortCutNotFound
  case arrowDangling
  case arrowLoopBackDangling
}
