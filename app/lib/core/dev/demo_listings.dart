import '../../data/models/fact_sheet.dart';
import '../../data/models/listing.dart';
import '../../data/models/listing_status.dart';

/// Canned listings so the shell has something to show before sections 5 to 7
/// build the real ones.
///
/// Only ever loaded when [DevAccounts.enabled] is true, the same switch the
/// canned phone number sits behind. A release build shows an empty Home,
/// which is the correct first screen for a seller who has published nothing.
///
/// The titles are deliberately in the seller's own words rather than
/// translated: on a real listing this text is whatever they said into the
/// microphone, and it is never localised.
abstract final class DemoListings {
  static List<Listing> get listings => [
        const Listing(
          id: 'demo-1',
          status: ListingStatus.published,
          title: 'Blue pottery water jug',
          description: 'A hand-thrown jug, glazed blue, holds two litres.',
          imageUrls: ['assets/images/crafts/pottery.jpg'],
          factSheet: FactSheet(
            material: 'Clay',
            colour: 'Blue',
            quantity: 3,
            priceInPaise: 45000,
          ),
        ),
        const Listing(
          id: 'demo-2',
          status: ListingStatus.needsAttention,
          title: 'Cotton shawl, red border',
          imageUrls: ['assets/images/crafts/weaving.jpg'],
          followUpQuestion: 'How wide is the shawl?',
          factSheet: FactSheet(
            material: 'Cotton',
            colour: 'Red',
            quantity: 1,
            priceInPaise: 120000,
          ),
        ),
        const Listing(
          id: 'demo-3',
          status: ListingStatus.processing,
          title: 'Brass oil lamp',
          imageUrls: ['assets/images/crafts/metalwork.jpg'],
          factSheet: FactSheet(material: 'Brass', quantity: 2),
        ),
      ];
}
