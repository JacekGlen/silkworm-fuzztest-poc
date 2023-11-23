#include "fuzztest/fuzztest.h"
#include "gtest/gtest.h"

#include <boost/asio/async_result.hpp>
#include <boost/asio/awaitable.hpp>
#include <boost/asio/buffer.hpp>
#include <boost/asio/co_spawn.hpp>
#include <boost/asio/detached.hpp>
#include <boost/asio/io_context.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <boost/asio/use_future.hpp>
#include <nlohmann/json.hpp>

TEST(MyTestSuite, OnePlustTwoIsTwoPlusOne) {
  EXPECT_EQ(1 + 2, 2 + 1);
}

void IntegerAdditionCommutes(int a, int b) {
  EXPECT_EQ(a + b, b + a);
}

FUZZ_TEST(MyTestSuite, IntegerAdditionCommutes);



class RequestHandler_ForTest {
  public:
    boost::asio::awaitable<void> handle_request(const std::string& request_str) {
        try {
            co_await is_valid_json(request_str);
        } catch (const std::invalid_argument& e) {
            std::cerr << "Invalid argument: " << e.what() << std::endl;
        } catch (...) {
            std::cerr << "Error occurred" << std::endl;
        }
    }

    boost::asio::awaitable<bool> is_valid_json(const std::string& request_str) {
        if (request_str.length() == 20) {
            std::cout << "JG request_str: " << request_str << std::endl;
            throw std::invalid_argument("Invalid argument");
        }

        co_return nlohmann::json::accept(request_str);
    }
};

void FuzzerTestOneInput(const std::string& request_str) {
    try {
        auto io_context = boost::asio::io_context{};
        auto result = boost::asio::co_spawn(
            io_context, [&request_str]() -> boost::asio::awaitable<void> {
                try {
                    RequestHandler_ForTest handler{};
                    co_await handler.handle_request(request_str);
                } catch (const std::exception& e) {
                    std::cerr << e.what() << '\n';
                }
            },
            boost::asio::use_future);

        io_context.run();

        result.get();

        io_context.restart();

    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    } catch (...) {
        std::cout << "Error" << std::endl;
    }
}

FUZZ_TEST(SilkwormTestSuite, FuzzerTestOneInput);
