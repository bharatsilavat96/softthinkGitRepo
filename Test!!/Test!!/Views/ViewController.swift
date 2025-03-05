//
//  ViewController.swift
//  Test!!
//
//  Created by Bharat Shilavat on 03/03/25.
//

import UIKit

class ViewController: UIViewController {
    
    private var viewModel : DemoViewModel = DemoViewModel()
    
    @IBOutlet weak var demoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        demoTableView.showsVerticalScrollIndicator = false
        demoTableView.dataSource = self
        demoTableView.delegate = self
        demoTableView.estimatedRowHeight = 400
        demoTableView.rowHeight = UITableView.automaticDimension
        demoTableView.separatorInset = .zero
        demoTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        demoTableView.dataSource = self
        demoTableView.delegate = self
        
        viewModel.integrationList.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.demoTableView.reloadData()
            }
        }
        viewModel.fetchData()
    }
}

//MARK: - UITableViewDataSource -
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.integrationList.value.meals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DemoViewControllerContent.Content.demoCelID, for: indexPath) as! CustomTableViewCell
        cell.delegate = self
        let mealData = self.viewModel.integrationList.value.meals?[indexPath.row]
        viewModel.downloadImage(usingUrl: mealData?.strMealThumb ?? DemoViewControllerContent.Content.plahlderImgStr) { image in
            DispatchQueue.main.async {
                if let image = image {
                    cell.productImageView.image = image
                }
            }
        }
        cell.likeButtin.tag = indexPath.row
        cell.viewMoreButton.tag = indexPath.row
        cell.productTitleLabel.text = mealData?.strMeal
        cell.thumbnilImgUrl = mealData?.strMealThumb
        cell.ingredients = mealData?.ingredients ?? []
        cell.productTitleLabel.text = mealData?.strMeal
        cell.productDescriptionLabel.text = mealData?.strInstructions
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
}

//MARK: - CustomTableViewCellDelegate -
extension ViewController : CustomTableViewCellDelegate {
    func likeButtonTapped(atIndex: Int) {
        debugPrint("likeButtonTapped -> \(atIndex)")
    }
    
    func viewMoreButtonTapped(atIndex: Int) {
        guard let mealDataSourceUrl = self.viewModel.integrationList.value.meals?[atIndex].strSource,
              !mealDataSourceUrl.isEmpty else {
            print("Invalid URL or URL is empty")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: DemoViewControllerContent.Content.detailVCID) as? DetailViewController {
            detailVC.urlString = mealDataSourceUrl
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
