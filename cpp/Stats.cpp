#include <atomic>
#include <iostream>
#include <map>
#include <mutex>
#include <string>

// This is not fast or good
struct Counter {
  typedef int64_t size_type;

  Counter(): value_(0) {}
  explicit Counter(const std::atomic<Counter::size_type>& value): value_() {
    value_.store(value.load());
  }
  Counter(const Counter& counter): value_(counter.get()) {}

  Counter::size_type incr(Counter::size_type count = 1) {
    return value_.fetch_add(count);
  }
  void update(Counter::size_type value) {
    value_.store(value);
  }
  Counter::size_type decr(Counter::size_type count = 1) {
    return value_.fetch_sub(count);
  }
  Counter::size_type get() const {
    return value_.load();
  }

 private:
  std::atomic<Counter::size_type> value_;
};

struct Stats {
  Stats(): counterMutex_(), counters_() {}

  Counter::size_type incr(const std::string& name,
                          Counter::size_type count = 1) {
    return getCounter(name).incr(count);
  }

  Counter& getCounter(const std::string& name) {
    std::lock_guard<std::mutex> lock(counterMutex_);
    std::map<std::string, Counter>::iterator it = counters_.find(name);
    if (it != counters_.end()) {
      return it->second;
    } else {
      counters_.insert(std::pair<std::string,Counter>(name, Counter()));
      return counters_.find(name)->second;
    }
  }

 private:
  std::mutex counterMutex_;
  std::map<std::string, Counter> counters_;
};

using namespace std;

static Stats GlobalStats;
int main() {
  GlobalStats.incr("hello");
  cout << GlobalStats.getCounter("hello").get() << endl;
  GlobalStats.incr("hello");
  cout << GlobalStats.getCounter("hello").get() << endl;
}
