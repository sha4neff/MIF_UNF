#Область ПрограммныйИнтерфейс

//Определяет использование актов о расхождении после приемки для документа
//
//Параметры:
//  Документ     - ДокументСсылка - документ, для которого необходимо определить возможность использования актов о расхождении.
//  Используется - Булево - в данный параметр необходимо установить признак использования актов, по умолчанию установлен в Ложь.
//
Процедура ОпределитьИспользованиеАктовОРасхожденииПослеПриемки(Документ, Используется) Экспорт
	
	ИнтеграцияИСМПУНФ.ОпределитьИспользованиеАктовОРасхожденииПослеПриемки(Документ, Используется);
	
КонецПроцедуры

//Заполняет переданную таблицу данные из ТЧ документа.
//
//Параметры:
//   Документ - ДокументСсылка - Документ из ТЧ которого будет происходить заполнение.
//   ТаблицаПродукции - ТаблицаЗначений - Таблица для заполнения данными из документа.
//   ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС, Массив из ПеречислениеСсылка.ВидыПродукцииИС - 
//     вид(ы) маркируемой продукции, которым(и) необходимо заполнить таблицу.
//
Процедура СформироватьТаблицуМаркируемойПродукцииДокумента(Документ, ТаблицаПродукции, ВидМаркируемойПродукции) Экспорт
	
	ИнтеграцияИСМПУНФ.СформироватьТаблицуМаркируемойПродукцииДокумента(Документ, ТаблицаПродукции, ВидМаркируемойПродукции);
	
КонецПроцедуры

//Заполняет таблицу маркированный товаров по выбранным документам.
//
//Параметры:
//   Запрос - Запрос - запрос, в котором требуется сформировать временную таблицу.
//   ИсточникОснований - Строка - Имя временной таблицы с колонкой "ДокументОснование".
//   СтандартнаяОбработка - Булево - Необходимость обработки события "по-умолчанию" (установить Ложь при переопределении).
//
Процедура СформироватьТаблицуМаркированныхТоваровОснований(Запрос, ИсточникОснований, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияИСМПУНФ.СформироватьТаблицуМаркированныхТоваровОснований(Запрос, ИсточникОснований, СтандартнаяОбработка);
	
КонецПроцедуры

//Дополнительные действия прикладной конфигурации при изменении статуса документа ИСМП.
//
//Параметры:
//   ДокументСсылка   - ДокументСсылка     - ссылка на документ с изменением статуса.
//   ПредыдущийСтатус - ПеречислениеСсылка - предыдущий статус обработки.
//   НовыйСтатус      - ПеречислениеСсылка - новый статус обработки.
//   ПараметрыОбновленияСтатуса - Структура, Неопределено - (См. ИнтеграцияИСМПСлужебныйКлиентСервер.ПараметрыОбновленияСтатуса).
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса = Неопределено) Экспорт

	Возврат;

КонецПроцедуры

#Область Серии

//Предназачена для реализации механизма генерации серий номенклатуры по переданным данным
//  (См. ИнтеграцияИСМП.СгенерироватьСерии)
//
Процедура СгенерироватьСерии(ДанныеДляГенерации, ВидМаркируемойПродукции) Экспорт

	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Номенклатура

// Определяет заполнение Товарного знака по номенклатуре.
// 
// Параметры:
// 	Номенклатура - Массив из ОпределяемыйТип.Номенклатура - Исходные данные для заполнения.
// 	ТоварныеЗнакиПоНоменклатуре - Соответствие:
// 	 * Ключ     - ОпределяемыйТип.Номенклатура - Значение номенклатуры из исходных данных.
// 	 * Значение - Строка, произвольный         - Товарный знак по номенклатуре (значение будет конвертировано в строку).
Процедура ТоварныеЗнакиПоНоменклатуре(Номенклатура, ТоварныеЗнакиПоНоменклатуре) Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область КаталогGS46

// Заполняет свойства номенклатуры, используемые для передачи в каталог GS46. Могут быть заполнены колонки:
//   * Торговая марка,
//   * Страна производства,
//   * Вид обуви,
//   * Материал верха,
//   * Материал подкладки,
//   * Материал низа,
//   * Цвет,
//   * Размер.
// 
// Параметры:
//   Товары - ДанныеФормыКоллекция - таблица для заполнения.
//
Процедура ЗаполнитьСвойстваНоменклатурыДляКаталогаGS46(Товары) Экспорт
	
	ИнтеграцияИСМПУНФ.ЗаполнитьСвойстваНоменклатурыДляКаталогаGS46(Товары);
	
КонецПроцедуры

Процедура ЗагрузитьПолученныеGTINКаталогаGS46(Товары) Экспорт
	
	ИнтеграцияИСМПУНФ.ЗагрузитьПолученныеGTINКаталогаGS46(Товары);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ПанельОбменаИСМП

//Предназачена для модификации текста запроса по расчету неоформленных документов ЭДО.
//   Сценарий использования: заменить текст запроса на требуемый (требующие оформления
//   с помощью ЭДО документы продажи с маркируемой продукцией).
//
//Параметры:
//  ТекстЗапроса - Строка - Текст запроса
//
Процедура ПриПолучениТекстаЗапросаНеоформленныхДокументовЭДО(ТекстЗапроса) Экспорт
	
	ИнтеграцияИСМПУНФ.ПриПолучениТекстаЗапросаНеоформленныхДокументовЭДО(ТекстЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область ПанельАдминистрированияИСМП

// Предназначения для управления признаком возможности включения / отключения ведения учета МРЦ табачной продукции.
// При заполнении причины - соответствующая доступность изменяется, на форме отображатеся указанная причина.
// Например, можно запретить отключение функции, если ведется учет МРЦ в составе серий или характеристик.
// 
//Параметры:
//  ВозможноВключение              - Булево - Признак возможности включения.
//  ПричинаНевозможностиВключения  - Строка - Причина, по которой невозможно включить учет МРЦ.
//  ВозможноОтключение             - Булево - Признак возможности отключения.
//  ПричинаНевозможностиОтключения - Строка - Причина, по которой невозможно выключить учет МРЦ.
Процедура ПриОпределенииВозможностиВключенияОтключенияВеденияУчетаМРЦ(ВозможноВключение, ПричинаНевозможностиВключения, ВозможноОтключение, ПричинаНевозможностиОтключения) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область МаркировкаОстатков

// Определяет ссылку на документ-основание маркировки товаров, как документ, являющийся основанием для маркировки остатков.
// 
// Параметры:
// 	СсылкаНаДокумент   - ОпределяемыйТип.ОснованиеМаркировкаТоваровИСМП - Ссылка на проверямый документ.
// 	ЯвляетсяОснованием - Булево                                         - Выходной параметр.
Процедура ЯвляетсяОснованиемДляМаркировкиОстатков(СсылкаНаДокумент, ЯвляетсяОснованием) Экспорт
	
	ИнтеграцияИСМПУНФ.ЯвляетсяОснованиемДляМаркировкиОстатков(СсылкаНаДокумент, ЯвляетсяОснованием);
	
КонецПроцедуры

#КонецОбласти

//Получение ссылки ТН ВЭД по коду.
//
//Параметры:
//  КодТНВЭД - Строка - Код по классификатору товарной номенклатуры внешнеэкономической деятельности.
//  ТНВЭД - Произвольный - искомый элемент.
//
Процедура КлассификаторТНВЭД(КодТНВЭД, ТНВЭД) Экспорт
	
	ИнтеграцияИСМПУНФ.КлассификаторТНВЭД(КодТНВЭД, ТНВЭД);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийДокументов

//Вызывается при вводе документа на основании, при выполнении метода Заполнить или при интерактивном вводе нового.
//
//Параметры:
//   ДокументОбъект - ДокументОбъект - заполняемый документ,
//   ДанныеЗаполнения - Произвольный - значение, которое используется как основание для заполнения,
//   ТекстЗаполнения - Строка, Неопределено - текст, используемый для заполнения документа,
//   СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполненияДокумента(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	ИнтеграцияИСМПУНФ.ОбработкаЗаполненияДокумента(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Отладка

Процедура ПриОпределенииПутиКФайлуЛогирования(ПутьКФайлу) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывается расширением формы при необходимости проверки заполнения реквизитов при записи или при проведении документа в форме,
// а также при выполнении метода ПроверитьЗаполнение.
//
// Параметры:
//  ДокументОбъект - ДокументОбъект - проверяемый документ,
//  Отказ - Булево - признак отказа от проведения документа,
//  ПроверяемыеРеквизиты - Массив - массив путей к реквизитам, для которых будет выполнена проверка заполнения,
//  МассивНепроверяемыхРеквизитов - Массив - массив путей к реквизитам, для которых не будет выполнена проверка заполнения.
Процедура ПриОпределенииОбработкиПроверкиЗаполнения(ДокументОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов) Экспорт
	
	ИнтеграцияИСМПУНФ.ПриОпределенииОбработкиПроверкиЗаполнения(ДокументОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область GTIN

// Дополняет массив текстов запроса получения GTIN для объединения.
// Ожидается, что в результате запроса будут получены значения GTIN(EAN).
// Во входящем параметре запроса текс запроса уже имеется, необходимо добавлять тексты запроса для объединеия:
// без псевдонимов и с количеством выбираемых полей - 1.
// В запросе установлены параметры: &Номенклатура, &Характеристика - данные из текущей коллекции.
//
// Параметры:
//  ТекущиеДанные         - ДанныеФормыЭлементКоллекции - Текущая строка формы.
//  Объект                - ДанныеФормыСтруктура        - Текущая строка формы.
//  Запрос                - Запрос                      - Запрос, в который можно установить параметры.
//  МассивТекстовЗапросов - Массив из Строка            - Тексты запроса для объединеиня.
Процедура ДополнитьПараметрыЗапросаПриНачалеВыбораGTIN(ТекущиеДанные, Объект, Запрос, МассивТекстовЗапросов) Экспорт
	
	ИнтеграцияИСМПУНФ.ДополнитьПараметрыЗапросаПриНачалеВыбораGTIN(ТекущиеДанные,
		Объект,
		Запрос,
		МассивТекстовЗапросов);
	
КонецПроцедуры

#КонецОбласти

#Область ЭлектроннаяПодпись

// Предназначена для получения сертификата на компьютере по строке отпечатка.
// (См. ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку)
//
// Параметры:
//   Сертификат             - СертификатКриптографии - найденный сертификат электронной подписи и шифрования.
//   Отпечаток              - Строка - Base64 кодированный отпечаток сертификата.
//   ТолькоВЛичномХранилище - Булево - если Истина, тогда искать в личном хранилище, иначе везде.
//   СтандартнаяОбработка   - Булево - признак обработки стандартной библиотекой (установить Ложь при переопределении)
//
Процедура ПриОпределенииСертификатаПоОтпечатку(Сертификат, Отпечаток, ТолькоВЛичномХранилище, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Процедура заполняет признак использования производства на стороне.
//
// Параметры:
//  Используется - Булево - Признак использования производства на стороне.
Процедура ИспользуетсяПереработкаНаСтороне(Используется) Экспорт

	ИнтеграцияИСМПУНФ.ИспользуетсяПереработкаНаСтороне(Используется);

КонецПроцедуры

// Процедура заполняет признак использования гос.контрактов по 275ФЗ.
//
// Параметры:
//  Используется - Булево - Признак использования гос.контрактов по 275ФЗ. Значение по умолчанию Ложь.
Процедура ИспользуетсяПоддержкаПлатежейВСоответствииС275ФЗ(Используется) Экспорт

	Возврат;

КонецПроцедуры

// Процедура заполняет признак использования передачи товаров между организациями.
// Вызывается из документа ОтгрузкаТоваровИСМП для определения доступных типов элемента формы Контрагент.
//
// Параметры:
//  Используется - Булево - Признак использования передачи товаров между организациями, значение по умолчанию Ложь.
Процедура ПриОпределенииИспользованияПередачиТоваровМеждуОрганизациями(Используется) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПриОпределенииСкладаДокументаОснования(Склад, ДокументОснование) Экспорт
	
	ИнтеграцияИСМПУНФ.ПриОпределенииСкладаДокументаОснования(Склад, ДокументОснование);
	
КонецПроцедуры

Процедура ЗаполнитьКодыТНВЭДПоНоменклатуреВТабличнойЧасти(ТабличнаяЧасть) Экспорт
	
	ИнтеграцияИСМПУНФ.ЗаполнитьКодыТНВЭДПоНоменклатуреВТабличнойЧасти(ТабличнаяЧасть);
	
КонецПроцедуры

#КонецОбласти
