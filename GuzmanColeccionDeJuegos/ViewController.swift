//
//  ViewController.swift
//  GuzmanColeccionDeJuegos
//
//  Created by Lin Abigail Guzman Gutierrez on 2/10/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    
    @IBOutlet weak var tableView: UITableView!
    var juegos : [Juego] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let juegoMovido = juegos[sourceIndexPath.row]
       
        juegos.remove(at: sourceIndexPath.row)
        juegos.insert(juegoMovido, at: destinationIndexPath.row)

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        }catch{
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(juegos[indexPath.row])
           
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            juegos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

