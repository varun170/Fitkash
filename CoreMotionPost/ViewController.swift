import UIKit
import CoreMotion
import Dispatch
var wallet = 0
class ViewController: UIViewController {

    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    private var shouldStartUpdating: Bool = false
    private var startDate: Date? = nil
    private var my_money = 0
    private var my_steps = 0
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stepsCountLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if(wallet>0){
            self.moneyLabel.text = String(wallet) + " FitCoins"
        }
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let startDate = startDate else { return }
        updateStepsCountLabelUsing(startDate: startDate)
    }

    @objc private func didTapStartButton() {
        shouldStartUpdating = !shouldStartUpdating
        shouldStartUpdating ? (onStart()) : (onStop())
    }
}


extension ViewController {

    private func onStart() {
        startButton.setTitle("Stop", for: .normal)
        startDate = Date()
        checkAuthorizationStatus()
        startUpdating()
    }

    private func onStop() {
        startButton.setTitle("Start", for: .normal)
        startDate = nil
        my_money = my_steps / 100
        wallet = my_money
        moneyLabel.text = String(my_money) + " FitCoins"
        stopUpdating()
    }

    private func startUpdating() {
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        } else {
            stepsCountLabel.text = "Not available"
        }
    }

    private func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            onStop()
            stepsCountLabel.text = "Not available"
        default:break
        }
    }

    private func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }

    private func on(error: Error) {
        //handle error
    }

    private func updateStepsCountLabelUsing(startDate: Date) {
        pedometer.queryPedometerData(from: startDate, to: Date()) {
            [weak self] pedometerData, error in
            if let error = error {
                self?.on(error: error)
            } else if let pedometerData = pedometerData {
                DispatchQueue.main.async {
                    self?.stepsCountLabel.text = String(describing: pedometerData.numberOfSteps)
                }
            }
        }
    }

    private func startCountingSteps() {
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }

            DispatchQueue.main.async {
                self?.stepsCountLabel.text = pedometerData.numberOfSteps.stringValue
                self?.my_steps = Int(pedometerData.numberOfSteps.int16Value)
            }
        }
    }
}

