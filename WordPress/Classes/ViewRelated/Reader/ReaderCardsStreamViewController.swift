import Foundation

class ReaderCardsStreamViewController: ReaderStreamViewController {
    private var currentPage = 1

    lazy var cardsService: ReaderCardService = {
        return ReaderCardService()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        ReaderWelcomeBanner.presentIfNeeded(in: tableView)
    }

    // MARK: - TableView Related

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let posts = content.content as? [ReaderCard], let cardPost = posts[indexPath.row].post {
            return cell(for: cardPost, at: indexPath)
        } else {
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let posts = content.content as? [ReaderCard], let post = posts[indexPath.row].post {
            didSelectPost(post, at: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)

        if let posts = content.content as? [ReaderCard], let post = posts[indexPath.row].post {
            bumpRenderTracker(post)
        }
    }

    // MARK: - Sync

    override func fetch(for topic: ReaderAbstractTopic, success: @escaping ((Int, Bool) -> Void), failure: @escaping ((Error?) -> Void)) {
        cardsService.fetch(page: 1, success: success, failure: failure)
    }

    override func loadMoreItems(_ success: ((Bool) -> Void)?, failure: ((NSError) -> Void)?) {
        footerView.showSpinner(true)

        currentPage += 1

        cardsService.fetch(page: currentPage, success: { _, hasMore in
            success?(hasMore)
        }, failure: { error in
            guard let error = error else {
                return
            }

            failure?(error as NSError)
        })
    }

    // MARK: - TableViewHandler

    override func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ReaderCard.classNameWithoutNamespaces())
        fetchRequest.sortDescriptors = sortDescriptorsForFetchRequest(ascending: true)
        return fetchRequest
    }

    override func predicateForFetchRequest() -> NSPredicate {
        return NSPredicate(format: "post == NULL OR post != null")
    }

    /// Convenience method for instantiating an instance of ReaderCardsStreamViewController
    /// for a existing topic.
    ///
    /// - Parameters:
    ///     - topic: Any subclass of ReaderAbstractTopic
    ///
    /// - Returns: An instance of the controller
    ///
    class func controller(topic: ReaderAbstractTopic) -> ReaderCardsStreamViewController {
        let controller = ReaderCardsStreamViewController()
        controller.readerTopic = topic
        return controller
    }
}
