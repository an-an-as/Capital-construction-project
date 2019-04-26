import UIKit
protocol SegueProtocol {
    associatedtype SegueIdentifier: RawRepresentable
}
extension SegueProtocol where Self: UIViewController, SegueIdentifier.RawValue == String {
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError("Unknown segue: \(segue))") }
        return segueIdentifier
    }
    func performSegue(withIdentifier segueIdentifier: SegueIdentifier) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: nil)
    }
}

extension MasterViewController: SegueProtocol {
    enum SegueIdentifier: String {
        case detail = "showDetail"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .detail:
            if let indexPath = tableView.indexPathForSelectedRow {
                let document = documents[indexPath.row]
                let controller = segue.destination as! DetailViewController
                controller.document = document
            }
        }
    }
}
performSegue(withIdentifier: .detail)
