#include <boost/program_options.hpp>
namespace po = boost::program_options;
#include <iostream>
#include <string>

int main(int argc, char *argv[]) {
    try {
        // Define and parse the command line arguments
        po::options_description desc("Options");
        desc.add_options() // clang-format off
            ("help", "Print usage information and exit")
            ("name", po::value<std::string>(), "The name of the person to greet")
        ; // clang-format on
        po::variables_map vm;
        po::store(po::parse_command_line(argc, argv, desc), vm);
        po::notify(vm);

        // Print a usage message if the --help flag was specified
        if (vm.count("help")) {
            std::cout << "Usage: " << argv[0] << " [options]\n\n"
                      << "Print a greeting message to the console.\n\n"
                      << desc << "\n";
            return 0;
        }

        // If the --name option was specified, use that name, otherwise ask the
        // user for his name in the console
        std::string name;
        if (vm.count("name")) {
            name = vm["name"].as<std::string>();
        } else {
            std::cout << "Please enter your name: ";
            std::getline(std::cin, name);
        }

        // Print the greeting message
        std::cout << "Hello, " << name << "!\n";

    } catch (std::exception &e) {
        // Print any errors we may run into (e.g. unrecognized options)
        std::cerr << "error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}