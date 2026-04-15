#include <iostream>
#include <string>
#include <cstdio>
#include <array>
#include <vector>
#include <algorithm>

using namespace std;

string exec(const string& cmd) {
    array<char, 256> buffer;
    string result;

    FILE* pipe = popen(cmd.c_str(), "r");
    if (!pipe) return "";

    while (fgets(buffer.data(), buffer.size(), pipe) != nullptr) {
        result += buffer.data();
    }

    pclose(pipe);
    return result;
}

string pingCommand(const string& host) {
#ifdef _WIN32
    return "ping -n 1 " + host + " 2>&1";
#else
    return "ping -c 1 " + host + " 2>&1";
#endif
}

bool isLiveMode(const string& input) {
    return input == "live";
}

bool hostResponded(const string& host) {
    string out = exec(pingCommand(host));

    return out.find("time=") != string::npos ||
           out.find("bytes from") != string::npos ||
           out.find("TTL=") != string::npos;
}

double safeToDouble(const string& t) {
    try {
        return stod(t);
    } catch (...) {
        return -1;
    }
}

string extractTime(const string& output) {
    size_t pos = output.find("time=");
    if (pos == string::npos) return "timeout";

    pos += 5;
    string ms;

    while (pos < output.size() &&
          (isdigit(output[pos]) || output[pos] == '.' || output[pos] == '<')) {

        if (output[pos] != '<')
            ms += output[pos];

        pos++;
    }

    if (ms.empty()) return "timeout";
    return ms;
}

void showStats(const vector<double>& times, int total, int failed) {
    if (times.empty()) {
        cout << "\nNo valid responses.\n";
        return;
    }

    double sum = 0;
    double mn = *min_element(times.begin(), times.end());
    double mx = *max_element(times.begin(), times.end());

    for (double t : times) sum += t;

    double avg = sum / times.size();
    double loss = (double)failed / total * 100.0;

    cout << "\n===== STATS =====\n";
    cout << "Min: " << mn << " ms\n";
    cout << "Max: " << mx << " ms\n";
    cout << "Avg: " << avg << " ms\n";
    cout << "Packet loss: " << loss << "%\n";
    cout << "=================\n";
}

void liveMode(const string& host) {
    cout << "\nLIVE MODE STARTED (CTRL+C to stop)\n\n";

    vector<double> times;
    int failed = 0;
    int count = 0;

    while (true) {
        string out = exec(pingCommand(host));
        string t = extractTime(out);

        count++;

        if (t == "timeout") {
            failed++;
            cout << "timeout\n";
        } else {
            double val = safeToDouble(t);

            if (val < 0) {
                failed++;
                cout << "timeout\n";
            } else {
                times.push_back(val);
                cout << val << " ms\n";
            }
        }

        // stats leves a cada 20 pings
        if (count % 20 == 0) {
            showStats(times, count, failed);
        }
    }
}

int main() {

    while (true) {

        cout << "=====================================\n";
        cout << "        Welcome to OhAPinger!        \n";
        cout << " OSS project made by bangkkuser      \n";
        cout << " GitHub: rebangkkuser                \n";
        cout << " If you want a live ping, type \"live\" in the test quantity.\n";
        cout << "=====================================\n\n";

        string host;
        string inputTests;

        cout << "Enter host/IP: ";
        cin >> host;

        cout << "Number of tests (or 'live'): ";
        cin >> inputTests;

        if (isLiveMode(inputTests)) {
            if (!hostResponded(host)) {
                cout << "The host did not respond.\n";
                continue;
            }

            cout << "The host responded, continuing...\n";

            liveMode(host);
            continue;
        }

        int tests;

        try {
            tests = stoi(inputTests);
        } catch (...) {
            cout << "Invalid input.\n";
            continue;
        }

        vector<double> times;
        int failed = 0;

        cout << "\nChecking host...\n";

        if (!hostResponded(host)) {
            cout << "The host did not respond.\n";
            continue;
        }

        cout << "The host responded, continuing the test.\n\n";

        for (int i = 1; i <= tests; i++) {

            string out = exec(pingCommand(host));
            string t = extractTime(out);

            if (t == "timeout") {
                cout << "Test " << i << ": timeout\n";
                failed++;
                continue;
            }

            double val = safeToDouble(t);

            if (val < 0) {
                cout << "Test " << i << ": timeout\n";
                failed++;
            } else {
                times.push_back(val);
                cout << "Test " << i << ": " << val << " ms\n";
            }
        }

        showStats(times, tests, failed);

        char again;
        cout << "\nDo you want to start a new test? [y/n]: ";
        cin >> again;

        if (again != 'y' && again != 'Y') {
            cout << "Exiting OhAPinger...\n";
            break;
        }

        cout << "\n\n";
    }

    return 0;
}
