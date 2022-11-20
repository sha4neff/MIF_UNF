
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.КонтрагентыНачальноеЗначение) = Тип("Массив") Тогда
		СписокКонтрагентов.ЗагрузитьЗначения(Параметры.КонтрагентыНачальноеЗначение);
		СписокКонтрагентов.ЗаполнитьПометки(Истина);
		Для Каждого ЭлементСписка Из СписокКонтрагентов Цикл
			Если ЭлементСписка.Значение.ЭтоГруппа Тогда
				ЭлементСписка.Картинка = БиблиотекаКартинок.Папка;
			Иначе
				ЭлементСписка.Картинка = БиблиотекаКартинок.Реквизит;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Параметры.КонтрагентыНачальноеЗначение) = Тип("СписокЗначений") Тогда
		СписокКонтрагентов = Параметры.КонтрагентыНачальноеЗначение;
	КонецЕсли;
		
	Если ПустаяСтрока(Параметры.ВариантПечатиНачальноеЗначение) Тогда
		Если СписокКонтрагентов.Количество() > 1 Или (СписокКонтрагентов.Количество() = 1 И СписокКонтрагентов[0].Значение.ЭтоГруппа) Тогда
			ВариантПечати = "Список";
		Иначе
			ВариантПечати = "Карточка";
		КонецЕсли;
	Иначе
		ВариантПечати = Параметры.ВариантПечатиНачальноеЗначение;
	КонецЕсли;
	
	ПараметрыОтправки = Новый Структура("Тема, Текст", "", "");
	
	ОбновитьКонтактнуюИнформациюНаСервере();
	Элементы.ТабДок.Редактирование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.СохранениеПечатнойФормы") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			ФайлыВоВременномХранилище = ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранноеЗначение);
			Если ВыбранноеЗначение.ВариантСохранения = "СохранитьВПапку" Тогда
				СохранитьПечатныеФормыВПапку(ФайлыВоВременномХранилище, ВыбранноеЗначение.ПапкаДляСохранения);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборФорматаВложений") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			СписокВложений = ПоместитьТабличныеДокументыВоВременноеХранилище(ВыбранноеЗначение);
			
			ПараметрыНовогоПисьма = Новый Структура;
			ПараметрыНовогоПисьма.Вставить("Тема", ПараметрыОтправки.Тема);
			ПараметрыНовогоПисьма.Вставить("Текст", ПараметрыОтправки.Текст);
			ПараметрыНовогоПисьма.Вставить("Вложения", СписокВложений);
			
			РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыНовогоПисьма);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	ОткрытьФорму("ОбщаяФорма.СохранениеПечатнойФормы", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ВыборФорматаВложений", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьКонтактнуюИнформациюНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовФормы

&НаКлиенте
Процедура ВариантПечатиПриИзменении(Элемент)
	
	ОбновитьКонтактнуюИнформациюНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеСоставомПечатиНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УправлениеСоставомПечатиНажатиеЗавершение", ЭтаФорма);
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаУправлениеСоставомПечатиКонтактнойИнформации", , ЭтаФорма,,,,ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеСоставомПечатиНажатиеЗавершение(СоставПечатиИзменен, ДополнительныеПараметры) Экспорт
	
	Если СоставПечатиИзменен <> Неопределено И СоставПечатиИзменен Тогда
		ОбновитьКонтактнуюИнформациюНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

// Процедура обновляет контактную информацию в зависимости от заданных настроек
//
&НаСервере
Процедура ОбновитьКонтактнуюИнформациюНаСервере()
	
	КонтрагентыКПечати = ПолучитьКонтрагентовКПечати(СписокКонтрагентов);
	
	Если ВариантПечати = "Карточка" Тогда
		ТабДок = СформироватьПечатнуюФормуКарточка(КонтрагентыКПечати.ВыгрузитьЗначения());
	ИначеЕсли ВариантПечати = "Список" Тогда
		ТабДок = СформироватьПечатнуюФормуСписок(КонтрагентыКПечати.ВыгрузитьЗначения());
	КонецЕсли;
	
	УстановитьПараметрыОтправки();
	
КонецПроцедуры

// Функция формирует табличный документ с контактной информацией в виде карточек контрагентов
//
// Параметры:
//  Контрагенты	 - массив - контрагенты для которых распечатывается контактная информация
// Возвращаемое значение:
//  ТабличныйДокумент 
&НаСервереБезКонтекста
Функция СформироватьПечатнуюФормуКарточка(Контрагенты)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_КонтактнаяИнформацияКарточка";
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КонтактнаяИнформацияКарточка";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	СтруктураОбластей = ЗаполнитьСтруктуруОбластейМакета("Карточка");
	НастройкиСоставаКИ = ЗагрузитьНастройкиСоставаКИ();
	
	КолонокКонтактныхЛиц = 3;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаКонтактнойИнформации();
	
	Запрос.УстановитьПараметр("ИспользуемыеВидыКИ", НастройкиСоставаКИ.ИспользуемыеВидыКИ);
	Запрос.УстановитьПараметр("КонтрагентИНН", НастройкиСоставаКИ.КонтрагентИНН);
	Запрос.УстановитьПараметр("Контрагенты", Контрагенты);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ВыборкаКонтрагенты = МассивРезультатов[1].Выбрать();
	ВыборкаКИКонтрагенты = МассивРезультатов[2].Выбрать();
	ВыборкаКонтактныеЛица = МассивРезультатов[3].Выбрать();
	ВыборкаКИКонтактныеЛица = МассивРезультатов[4].Выбрать();
	ВыборкаКИФизЛицо = МассивРезультатов[5].Выбрать();
	
	ПоискПоКонтрагенту = Новый Структура("Контрагент");
	
	Для Каждого Контрагент Из Контрагенты Цикл
		
		ПоискПоКонтрагенту.Контрагент = Контрагент;
		ВыборкаКонтрагенты.Сбросить();
		
		Если ВыборкаКонтрагенты.НайтиСледующий(ПоискПоКонтрагенту) Тогда
			
			ТД_Контрагент = Новый ТабличныйДокумент;
			
			СтруктураОбластей.КонтрагентПредставление.Параметры.Заполнить(ВыборкаКонтрагенты);
			ТД_Контрагент.Вывести(СтруктураОбластей.КонтрагентПредставление);
			СтруктураОбластей.КонтрагентДанные.Параметры.Заполнить(ВыборкаКонтрагенты);
			ТД_Контрагент.Вывести(СтруктураОбластей.КонтрагентДанные);
			
			ТД_ВидыКИ_Контрагентов = Новый ТабличныйДокумент;
			ТД_ЗначениеКИ_Контрагентов = Новый ТабличныйДокумент;
			Для Каждого ВидКИ Из НастройкиСоставаКИ.ИспользуемыеВидыКИ_Контрагентов Цикл
				СтруктураОбластей.КонтрагентВидКИ.Параметры.ВидКИ = ВидКИ;
				ТД_ВидыКИ_Контрагентов.Вывести(СтруктураОбластей.КонтрагентВидКИ);
			КонецЦикла;
			
			ВыборкаКИКонтрагенты.Сбросить();
			ТекущаяСтрокаКИ = 0;
			
			Пока ВыборкаКИКонтрагенты.НайтиСледующий(ПоискПоКонтрагенту) Цикл
				
				СтрокаВыводаКИ = НастройкиСоставаКИ.ИспользуемыеВидыКИ_Контрагентов.Найти(ВыборкаКИКонтрагенты.ВидКИ);
				
				Пока ТекущаяСтрокаКИ < СтрокаВыводаКИ Цикл
					ТД_ЗначениеКИ_Контрагентов.Вывести(СтруктураОбластей.КонтрагентЗначениеКИ);
					ТекущаяСтрокаКИ = ТекущаяСтрокаКИ + 1;
				КонецЦикла;
				
				СтруктураОбластей.КонтрагентЗначениеКИ.Параметры.Заполнить(ВыборкаКИКонтрагенты);
				ТД_ЗначениеКИ_Контрагентов.Вывести(СтруктураОбластей.КонтрагентЗначениеКИ);
				СтруктураОбластей.КонтрагентЗначениеКИ.Параметры.ЗначениеКИКонтрагента = "";
				
				ТекущаяСтрокаКИ = ТекущаяСтрокаКИ + 1;
				
			КонецЦикла;
			
			Пока ТекущаяСтрокаКИ <= НастройкиСоставаКИ.ИспользуемыеВидыКИ_Контрагентов.ВГраница() Цикл
				ТД_ЗначениеКИ_Контрагентов.Вывести(СтруктураОбластей.КонтрагентЗначениеКИ);
				ТекущаяСтрокаКИ = ТекущаяСтрокаКИ + 1;
			КонецЦикла;
			
			ТД_Контрагент.Присоединить(ТД_ВидыКИ_Контрагентов.ПолучитьОбласть(1,1,ТД_ВидыКИ_Контрагентов.ВысотаТаблицы, ТД_ВидыКИ_Контрагентов.ШиринаТаблицы));
			ТД_Контрагент.Присоединить(ТД_ЗначениеКИ_Контрагентов.ПолучитьОбласть(1,1,ТД_ЗначениеКИ_Контрагентов.ВысотаТаблицы, ТД_ЗначениеКИ_Контрагентов.ШиринаТаблицы));
			ТД_Контрагент.Вывести(СтруктураОбластей.Отступ);
			
			Если НастройкиСоставаКИ.ОсновноеКонтактноеЛицо Или НастройкиСоставаКИ.ПрочиеКонтактныеЛица Тогда
				
				ТД_Контрагент.Вывести(СтруктураОбластей.КонтактныеЛицаЗаголовок);
				
				ТД_КонтактныеЛица = Новый ТабличныйДокумент;
				ТекущаяКолонкаКонтактныхЛиц = 0;
				ВыборкаКонтактныеЛица.Сбросить();
				
				Пока ВыборкаКонтактныеЛица.НайтиСледующий(ПоискПоКонтрагенту) Цикл
					
					Если (ВыборкаКонтактныеЛица.ОсновноеИлиПрочиеКонтактныеЛица = 1 И НЕ НастройкиСоставаКИ.ОсновноеКонтактноеЛицо)
						ИЛИ (ВыборкаКонтактныеЛица.ОсновноеИлиПрочиеКонтактныеЛица = 2 И НЕ НастройкиСоставаКИ.ПрочиеКонтактныеЛица) Тогда
							Продолжить;
					КонецЕсли;
					
					ТД_КонтактноеЛицо = Новый ТабличныйДокумент;
					СтруктураОбластей.КонтактноеЛицо.Параметры.Заполнить(ВыборкаКонтактныеЛица);
					ТД_КонтактноеЛицо.Вывести(СтруктураОбластей.КонтактноеЛицо);
					ТекущаяКолонкаКонтактныхЛиц = ТекущаяКолонкаКонтактныхЛиц + 1;
						
					ПоискПоКонтактномуЛицу = Новый Структура("КонтактноеЛицо", ВыборкаКонтактныеЛица.КонтактноеЛицо);
					ТекущаяСтрокаКИ = 0;
					ВыборкаКИКонтактныеЛица.Сбросить();
					
					Пока ВыборкаКИКонтактныеЛица.НайтиСледующий(ПоискПоКонтактномуЛицу) Цикл
						СтруктураОбластей.КонтактноеЛицоКИ.Параметры.Заполнить(ВыборкаКИКонтактныеЛица);
						ТД_КонтактноеЛицо.Вывести(СтруктураОбластей.КонтактноеЛицоКИ);
						ТекущаяСтрокаКИ = ТекущаяСтрокаКИ + 1;
					КонецЦикла;
					
					СтруктураОбластей.КонтактноеЛицоКИ.Параметры.ЗначениеКИКонтактногоЛица = "";
					Пока ТекущаяСтрокаКИ < НастройкиСоставаКИ.ИспользуемыеВидыКИ_КонтактныхЛиц.Количество() Цикл
						ТД_КонтактноеЛицо.Вывести(СтруктураОбластей.КонтактноеЛицоКИ);
						ТекущаяСтрокаКИ = ТекущаяСтрокаКИ + 1;
					КонецЦикла;
					
					Если ВыборкаКонтактныеЛица.ОсновноеИлиПрочиеКонтактныеЛица = 1 Тогда
						Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
						Область = ТД_КонтактноеЛицо.Область(1,2,ТД_КонтактноеЛицо.ВысотаТаблицы, ТД_КонтактноеЛицо.ШиринаТаблицы);
						Область.Обвести(Линия, Линия, Линия, Линия);
					КонецЕсли;
					
					Если ТекущаяКолонкаКонтактныхЛиц % КолонокКонтактныхЛиц = 1 Тогда
						ТД_КонтактныеЛица.Вывести(СтруктураОбластей.ОтступКЛ);
						ТД_КонтактныеЛица.Вывести(ТД_КонтактноеЛицо.ПолучитьОбласть(1,1,ТД_КонтактноеЛицо.ВысотаТаблицы, ТД_КонтактноеЛицо.ШиринаТаблицы));
					Иначе 
						ТД_КонтактныеЛица.Присоединить(ТД_КонтактноеЛицо.ПолучитьОбласть(1,1,ТД_КонтактноеЛицо.ВысотаТаблицы, ТД_КонтактноеЛицо.ШиринаТаблицы));
					КонецЕсли;
					
				КонецЦикла;
				
				СтруктураОбластей.КонтактноеЛицо.Параметры.КонтактноеЛицоПредставление = "";
				ДобавляемыеПустыеКолонкиКонтактныхЛиц = КолонокКонтактныхЛиц - (ТекущаяКолонкаКонтактныхЛиц % (КолонокКонтактныхЛиц + 1));
				ВыведеноПустыхКолонокКонтактныхЛиц = 0;
				Пока ВыведеноПустыхКолонокКонтактныхЛиц < ДобавляемыеПустыеКолонкиКонтактныхЛиц Цикл
					ТД_КонтактныеЛица.Присоединить(СтруктураОбластей.КонтактноеЛицо);
					ВыведеноПустыхКолонокКонтактныхЛиц = ВыведеноПустыхКолонокКонтактныхЛиц + 1;
				КонецЦикла;
				
				ТД_Контрагент.Вывести(ТД_КонтактныеЛица.ПолучитьОбласть(1,1,ТД_КонтактныеЛица.ВысотаТаблицы, ТД_КонтактныеЛица.ШиринаТаблицы));
				
			КонецЕсли;
			
			Если НастройкиСоставаКИ.ОтветственныйМенеджер Тогда
				
				ПоискПоОтветственному = Новый Структура("ФизЛицо", ВыборкаКонтрагенты.ФизЛицо);
				ВыборкаКИФизЛицо.Сбросить();
				
				Если ВыборкаКИФизЛицо.НайтиСледующий(ПоискПоОтветственному) Тогда
					СтруктураОбластей.Ответственный.Параметры.Заполнить(ВыборкаКИФизЛицо);
				Иначе
					СтруктураОбластей.Ответственный.Параметры.ТелефонОтветственного = "";
				КонецЕсли;
				
				СтруктураОбластей.Ответственный.Параметры.Заполнить(ВыборкаКонтрагенты);
				
				ТД_Контрагент.Вывести(СтруктураОбластей.Отступ);
				ТД_Контрагент.Вывести(СтруктураОбластей.Ответственный);
				
			КонецЕсли;
			
			Если НЕ ТабличныйДокумент.ПроверитьВывод(ТД_Контрагент) Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ТД_Контрагент);
			ТабличныйДокумент.Вывести(СтруктураОбластей.ОтступСПодчеркиванием);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Функция формирует табличный документ с контактной информацией в виде списка контрагентов
//
// Параметры:
//  Контрагенты	 - массив - контрагенты для которых распечатывается контактная информация
// Возвращаемое значение:
//  ТабличныйДокумент 
&НаСервереБезКонтекста
Функция СформироватьПечатнуюФормуСписок(Контрагенты)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_КонтактнаяИнформацияСписок";
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КонтактнаяИнформацияСписок";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	СтруктураОбластей = ЗаполнитьСтруктуруОбластейМакета("Список");
	НастройкиСоставаКИ = ЗагрузитьНастройкиСоставаКИ();
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаКонтактнойИнформации();
		Запрос.Текст = Запрос.Текст + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////" + "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ВложенныйЗапрос.КоличествоКонтактныхЛиц) КАК КоличествоКонтактныхЛиц
	|ИЗ
	|	(ВЫБРАТЬ
	|	СвязиКонтрагентКонтакт.Контрагент КАК Контрагент,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КонтактныеЛица.Ссылка) КАК КоличествоКонтактныхЛиц
	|ИЗ
	|	РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних КАК СвязиКонтрагентКонтакт
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛица КАК КонтактныеЛица
	|		ПО (КонтактныеЛица.Ссылка = СвязиКонтрагентКонтакт.Контакт)
	|ГДЕ
	|	СвязиКонтрагентКонтакт.Контрагент В(&Контрагенты)
	|	И КонтактныеЛица.ПометкаУдаления = ЛОЖЬ
	|	И КонтактныеЛица.Недействителен = ЛОЖЬ
	|	И СвязиКонтрагентКонтакт.СвязьНедействительна = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	СвязиКонтрагентКонтакт.Контрагент) КАК ВложенныйЗапрос";
	
	Запрос.УстановитьПараметр("ИспользуемыеВидыКИ", НастройкиСоставаКИ.ИспользуемыеВидыКИ);
	Запрос.УстановитьПараметр("КонтрагентИНН", НастройкиСоставаКИ.КонтрагентИНН);
	Запрос.УстановитьПараметр("Контрагенты", Контрагенты);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ВыборкаКонтрагенты = МассивРезультатов[1].Выбрать();
	ВыборкаКИКонтрагенты = МассивРезультатов[2].Выбрать();
	ВыборкаКонтактныеЛица = МассивРезультатов[3].Выбрать();
	ВыборкаКИКонтактныеЛица = МассивРезультатов[4].Выбрать();
	ВыборкаКИФизЛицо = МассивРезультатов[5].Выбрать();
	ВыборкаМаксКоличествоКонтактныхЛиц = МассивРезультатов[6].Выбрать();
	
	ВыборкаМаксКоличествоКонтактныхЛиц.Следующий();
	КолонокКонтактныхЛиц = ?(ВыборкаМаксКоличествоКонтактныхЛиц.КоличествоКонтактныхЛиц = NULL, 0, ВыборкаМаксКоличествоКонтактныхЛиц.КоличествоКонтактныхЛиц);
	Если НастройкиСоставаКИ.ОсновноеКонтактноеЛицо И НЕ НастройкиСоставаКИ.ПрочиеКонтактныеЛица Тогда
		КолонокКонтактныхЛиц = 1;
	ИначеЕсли НЕ НастройкиСоставаКИ.ОсновноеКонтактноеЛицо И НастройкиСоставаКИ.ПрочиеКонтактныеЛица Тогда
		КолонокКонтактныхЛиц = КолонокКонтактныхЛиц - 1;
	ИначеЕсли НЕ НастройкиСоставаКИ.ОсновноеКонтактноеЛицо И НЕ НастройкиСоставаКИ.ПрочиеКонтактныеЛица Тогда
		КолонокКонтактныхЛиц = 0;
	КонецЕсли;
	
	// ШАПКА
	ТабличныйДокумент.Вывести(СтруктураОбластей.КонтрагентЗаголовок);
	
	Для Каждого ВидКИ Из НастройкиСоставаКИ.ИспользуемыеВидыКИ_Контрагентов Цикл
		Область = СтруктураОбластей.ВидКИЗаголовок.Область(1,2,1,2);
		Если ВидКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
			Область.ШиринаКолонки = 25;
		Иначе
			Область.ШиринаКолонки = 14.5;
		КонецЕсли;
		СтруктураОбластей.ВидКИЗаголовок.Параметры.ВидКИ = ВидКИ;
		ТабличныйДокумент.Присоединить(СтруктураОбластей.ВидКИЗаголовок);
	КонецЦикла;
	
	Для Индекс = 1 По КолонокКонтактныхЛиц Цикл
		ТабличныйДокумент.Присоединить(СтруктураОбластей.КонтактноеЛицоЗаголовок);
	КонецЦикла;
	
	Если НастройкиСоставаКИ.ОтветственныйМенеджер Тогда
		ТабличныйДокумент.Присоединить(СтруктураОбластей.ОтветственныйЗаголовок);
	КонецЕсли;
	
	НомерЗаписиКонтрагента = 0;
	ПоискПоКонтрагенту = Новый Структура("Контрагент");
	
	// ДАННЫЕ
	Для Каждого Контрагент Из Контрагенты Цикл
		
		ПоискПоКонтрагенту.Контрагент = Контрагент;
		ВыборкаКонтрагенты.Сбросить();
		
		Если ВыборкаКонтрагенты.НайтиСледующий(ПоискПоКонтрагенту) Тогда
			
			НомерЗаписиКонтрагента = НомерЗаписиКонтрагента + 1;
			ТД_Контрагент = Новый ТабличныйДокумент;
			
			СтруктураОбластей.КонтрагентДанные.Параметры.Заполнить(ВыборкаКонтрагенты);
			ТД_Контрагент.Вывести(СтруктураОбластей.КонтрагентДанные);
			
			ВыборкаКИКонтрагенты.Сбросить();
			ТекущаяКолонкаВывода = 0;
			
			Пока ВыборкаКИКонтрагенты.НайтиСледующий(ПоискПоКонтрагенту) Цикл
				
				КолонкаВывода = НастройкиСоставаКИ.ИспользуемыеВидыКИ_Контрагентов.Найти(ВыборкаКИКонтрагенты.ВидКИ);
				Пока ТекущаяКолонкаВывода < КолонкаВывода Цикл
					ТД_Контрагент.Присоединить(СтруктураОбластей.КИДанные);
					ТекущаяКолонкаВывода = ТекущаяКолонкаВывода + 1;
				КонецЦикла;
				
				СтруктураОбластей.КИДанные.Параметры.Заполнить(ВыборкаКИКонтрагенты);
				ТД_Контрагент.Присоединить(СтруктураОбластей.КИДанные);
				СтруктураОбластей.КИДанные.Параметры.ЗначениеКИКонтрагента = "";
				ТекущаяКолонкаВывода = ТекущаяКолонкаВывода + 1;
				
			КонецЦикла;
			
			Пока ТекущаяКолонкаВывода <= НастройкиСоставаКИ.ИспользуемыеВидыКИ_Контрагентов.ВГраница() Цикл
				ТД_Контрагент.Присоединить(СтруктураОбластей.КИДанные);
				ТекущаяКолонкаВывода = ТекущаяКолонкаВывода + 1;
			КонецЦикла;
			
			Если НастройкиСоставаКИ.ОсновноеКонтактноеЛицо Или НастройкиСоставаКИ.ПрочиеКонтактныеЛица Тогда
				
				ВыборкаКонтактныеЛица.Сбросить();
				ТекущаяКолонкаВывода = 0;
				
				Пока ВыборкаКонтактныеЛица.НайтиСледующий(ПоискПоКонтрагенту) Цикл
					
					Если (ВыборкаКонтактныеЛица.ОсновноеИлиПрочиеКонтактныеЛица = 1 И НЕ НастройкиСоставаКИ.ОсновноеКонтактноеЛицо)
						ИЛИ (ВыборкаКонтактныеЛица.ОсновноеИлиПрочиеКонтактныеЛица = 2 И НЕ НастройкиСоставаКИ.ПрочиеКонтактныеЛица) Тогда
							Продолжить;
						КонецЕсли;
						
					ТД_КонтактноеЛицо = Новый ТабличныйДокумент;
					
					СтруктураОбластей.КонтактноеЛицоПредставление.Параметры.Заполнить(ВыборкаКонтактныеЛица);
					ТД_КонтактноеЛицо.Вывести(СтруктураОбластей.КонтактноеЛицоПредставление);
					
					ПоискПоКонтактномуЛицу = Новый Структура("КонтактноеЛицо", ВыборкаКонтактныеЛица.КонтактноеЛицо);
					ВыборкаКИКонтактныеЛица.Сбросить();
					
					Пока ВыборкаКИКонтактныеЛица.НайтиСледующий(ПоискПоКонтактномуЛицу) Цикл
						
						СтруктураОбластей.КонтактноеЛицоЗначениеКИ.Параметры.Заполнить(ВыборкаКИКонтактныеЛица);
						ТД_КонтактноеЛицо.Вывести(СтруктураОбластей.КонтактноеЛицоЗначениеКИ);
						
					КонецЦикла;
					
					ТекущаяКолонкаВывода = ТекущаяКолонкаВывода + 1;
					ТД_Контрагент.Присоединить(ТД_КонтактноеЛицо.ПолучитьОбласть(1,1,ТД_КонтактноеЛицо.ВысотаТаблицы, ТД_КонтактноеЛицо.ШиринаТаблицы));
					
				КонецЦикла;
				
				СтруктураОбластей.КИДанные.Параметры.ЗначениеКИКонтрагента = "";
				Пока ТекущаяКолонкаВывода < КолонокКонтактныхЛиц Цикл
					ТД_Контрагент.Присоединить(СтруктураОбластей.КИДанные);
					ТекущаяКолонкаВывода = ТекущаяКолонкаВывода + 1;
				КонецЦикла;
				
			КонецЕсли;
			
			Если НастройкиСоставаКИ.ОтветственныйМенеджер Тогда
				
				ПоискПоОтветственному = Новый Структура("ФизЛицо", ВыборкаКонтрагенты.ФизЛицо);
				ВыборкаКИФизЛицо.Сбросить();
				
				Если ВыборкаКИФизЛицо.НайтиСледующий(ПоискПоОтветственному) Тогда
					СтруктураОбластей.ОтветственныйДанные.Параметры.Заполнить(ВыборкаКИФизЛицо);
				Иначе
					СтруктураОбластей.ОтветственныйДанные.Параметры.ТелефонОтветственного = "";
				КонецЕсли;
				
				СтруктураОбластей.ОтветственныйДанные.Параметры.Заполнить(ВыборкаКонтрагенты);
				ТД_Контрагент.Присоединить(СтруктураОбластей.ОтветственныйДанные);
				
			КонецЕсли;
			
			ТД_Контрагент.Вывести(СтруктураОбластей.Отступ);
			
			Если НомерЗаписиКонтрагента % 2 = 0 Тогда
				Область = ТД_Контрагент.Область(1,1,ТД_Контрагент.ВысотаТаблицы, ТД_Контрагент.ШиринаТаблицы);
				Область.ЦветФона = Новый Цвет(245, 251, 247);
			КонецЕсли;
			
			Если НЕ ТабличныйДокумент.ПроверитьВывод(ТД_Контрагент) Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ТД_Контрагент);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Процедура задает значения по умолчанию для отправки электронного письма
//
&НаСервере
Процедура УстановитьПараметрыОтправки()
	
	ПараметрыОтправки.Тема = "Контактная информация контрагентов (" + ВариантПечати + ")" + " на " + Формат(ТекущаяДатаСеанса(), "ДФ=dd.MM.yyyy")
		+ ". Сформировал " + Пользователи.АвторизованныйПользователь() + ".";
	
КонецПроцедуры

// Функция получает контрагентов для печати контактной информации.
//
// Параметры:
//  СписокКонтрагентов	 - СписокЗначений	 - Список контрагентов может содержать элементы и группы справочника.
// Возвращаемое значение:
//  СписокЗначений - Список контрагентов, содержит только элементы. Имеющиеся группы разворачиваются до элементов.
&НаСервереБезКонтекста
Функция ПолучитьКонтрагентовКПечати(СписокКонтрагентов)
	
	КонтрагентыКПечати = Новый СписокЗначений;
	Контрагенты = ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(СписокКонтрагентов);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.Ссылка КАК Контрагент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка В ИЕРАРХИИ(&Ссылка)
		|	И Контрагенты.ПометкаУдаления = ЛОЖЬ
		|	И Контрагенты.ЭтоГруппа = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Контрагенты.Наименование";

	// Необходимо выполнять в цикле чтобы сохранилась заданная сортировка
	Для Каждого Контрагент Из Контрагенты Цикл
		Если Контрагент.ЭтоГруппа Тогда
			Запрос.УстановитьПараметр("Ссылка", Контрагент);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				КонтрагентыКПечати.Добавить(Выборка.Контрагент);
			КонецЦикла;
		Иначе
			КонтрагентыКПечати.Добавить(Контрагент);
		КонецЕсли;
	КонецЦикла;
		
	Возврат КонтрагентыКПечати;
	
КонецФункции

// Функция возвращает текст запроса по контрагентам, контактным лицам и ответственному, со всей контактной информацией
//
&НаСервереБезКонтекста
Функция ТекстЗапросаКонтактнойИнформации()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Контрагент,
	|	Контрагенты.Представление КАК КонтрагентПредставление,
	|	Контрагенты.НаименованиеПолное КАК НаименованиеПолное,
	|	ВЫБОР
	|		КОГДА &КонтрагентИНН = ИСТИНА
	|				И Контрагенты.ИНН <> """"
	|			ТОГДА ""ИНН: "" + Контрагенты.ИНН
	|		КОГДА Контрагенты.СтранаРегистрации <> ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|				И Контрагенты.РегистрационныйНомер <> """"
	|			ТОГДА ""Рег.№: "" + Контрагенты.РегистрационныйНомер
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ИННПредставление,
	|	Контрагенты.Ответственный КАК ОтветственныйМенеджер,
	|	Контрагенты.Ответственный.Представление КАК ОтветственныйПредставление,
	|	Контрагенты.Ответственный.Физлицо КАК ФизЛицо
	|ПОМЕСТИТЬ втКонтрагенты
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка В(&Контрагенты)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втКонтрагенты.Контрагент КАК Контрагент,
	|	втКонтрагенты.КонтрагентПредставление КАК КонтрагентПредставление,
	|	втКонтрагенты.НаименованиеПолное КАК НаименованиеПолное,
	|	втКонтрагенты.ИННПредставление КАК ИННПредставление,
	|	втКонтрагенты.ОтветственныйМенеджер КАК ОтветственныйМенеджер,
	|	втКонтрагенты.ОтветственныйПредставление КАК ОтветственныйПредставление,
	|	втКонтрагенты.ФизЛицо КАК ФизЛицо
	|ИЗ
	|	втКонтрагенты КАК втКонтрагенты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтрагентыКонтактнаяИнформация.Ссылка КАК Контрагент,
	|	КонтрагентыКонтактнаяИнформация.Вид КАК ВидКИ,
	|	КонтрагентыКонтактнаяИнформация.Представление КАК ЗначениеКИКонтрагента
	|ИЗ
	|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	КонтрагентыКонтактнаяИнформация.Ссылка В(&Контрагенты)
	|	И КонтрагентыКонтактнаяИнформация.Вид В(&ИспользуемыеВидыКИ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	КонтрагентыКонтактнаяИнформация.Вид.РеквизитДопУпорядочивания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СвязиКонтрагентКонтакт.Контрагент КАК Контрагент,
	|	КонтактныеЛица.Ссылка КАК КонтактноеЛицо,
	|	КонтактныеЛица.Представление КАК КонтактноеЛицоПредставление,
	|	ВЫБОР
	|		КОГДА КонтактныеЛица.Ссылка = СвязиКонтрагентКонтакт.Контрагент.КонтактноеЛицо
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК ОсновноеИлиПрочиеКонтактныеЛица
	|ИЗ
	|	РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних КАК СвязиКонтрагентКонтакт
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛица КАК КонтактныеЛица
	|		ПО СвязиКонтрагентКонтакт.Контакт = КонтактныеЛица.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиКонтрагентКонтакт.СрезПервых КАК СвязиКонтрагентКонтактСрезПервых
	|		ПО (СвязиКонтрагентКонтактСрезПервых.Контакт = КонтактныеЛица.Ссылка)
	|			И СвязиКонтрагентКонтакт.Контрагент = СвязиКонтрагентКонтактСрезПервых.Контрагент
	|ГДЕ
	|	СвязиКонтрагентКонтакт.Контрагент В(&Контрагенты)
	|	И КонтактныеЛица.ПометкаУдаления = ЛОЖЬ
	|	И КонтактныеЛица.Недействителен = ЛОЖЬ
	|	И СвязиКонтрагентКонтакт.СвязьНедействительна = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	СвязиКонтрагентКонтактСрезПервых.Порядок,
	|	КонтактныеЛица.Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СвязиКонтрагентКонтакт.Контрагент КАК Контрагент,
	|	КонтактныеЛицаКонтактнаяИнформация.Ссылка КАК КонтактноеЛицо,
	|	КонтактныеЛицаКонтактнаяИнформация.Вид КАК ВидКИ,
	|	КонтактныеЛицаКонтактнаяИнформация.Представление КАК ЗначениеКИКонтактногоЛица
	|ИЗ
	|	РегистрСведений.СвязиКонтрагентКонтакт.СрезПоследних КАК СвязиКонтрагентКонтакт
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛица.КонтактнаяИнформация КАК КонтактныеЛицаКонтактнаяИнформация
	|		ПО СвязиКонтрагентКонтакт.Контакт = КонтактныеЛицаКонтактнаяИнформация.Ссылка
	|ГДЕ
	|	СвязиКонтрагентКонтакт.Контрагент В(&Контрагенты)
	|	И КонтактныеЛицаКонтактнаяИнформация.Вид В(&ИспользуемыеВидыКИ)
	|	И КонтактныеЛицаКонтактнаяИнформация.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И КонтактныеЛицаКонтактнаяИнформация.Ссылка.Недействителен = ЛОЖЬ
	|	И СвязиКонтрагентКонтакт.СвязьНедействительна = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	КонтактныеЛицаКонтактнаяИнформация.Вид.РеквизитДопУпорядочивания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФизическиеЛицаКонтактнаяИнформация.Ссылка КАК ФизЛицо,
	|	ФизическиеЛицаКонтактнаяИнформация.Вид КАК ВидКИ,
	|	ФизическиеЛицаКонтактнаяИнформация.Представление КАК ТелефонОтветственного
	|ИЗ
	|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
	|ГДЕ
	|	ФизическиеЛицаКонтактнаяИнформация.Ссылка В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				втКонтрагенты.ФизЛицо
	|			ИЗ
	|				втКонтрагенты)
	|	И ФизическиеЛицаКонтактнаяИнформация.Вид В(&ИспользуемыеВидыКИ)
	|	И ФизическиеЛицаКонтактнаяИнформация.Ссылка.ПометкаУдаления = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизическиеЛицаКонтактнаяИнформация.Вид.РеквизитДопУпорядочивания";
	
	Возврат ТекстЗапроса;
		
КонецФункции

// Функция возвращает настройки состава печати для текущего пользователя
// Сперва получаются все существующие виды контактной информации и к ним применяются настройки пользователя.
//
// Возвращаемое значение:
//  Структура - Поля структуры:
// 		ИспользуемыеВидыКИ - массив всех видов контактной информации, выводящихся на печать,
// 		ИспользуемыеВидыКИ_Контрагентов - массив видов контактной информации контрагентов, выводящихся на печать,
// 		КонтрагентИНН - признак вывода ИНН контрагента,
// 		ОсновноеКонтактноеЛицо - признак вывода основного контактного лица,
// 		ПрочиеКонтактныеЛица - признак вывода прочих контактных лиц,
// 		ОтветственныйМенеджер - признак вывода ответственного менеджера.
&НаСервереБезКонтекста
Функция ЗагрузитьНастройкиСоставаКИ()
	
	НастройкиСоставаКИ = Новый Структура;
	НастройкиСоставаКИ.Вставить("ИспользуемыеВидыКИ", Новый Массив);
	НастройкиСоставаКИ.Вставить("ИспользуемыеВидыКИ_Контрагентов", Новый Массив);
	НастройкиСоставаКИ.Вставить("ИспользуемыеВидыКИ_КонтактныхЛиц", Новый Массив);
	НастройкиСоставаКИ.Вставить("КонтрагентИНН");
	НастройкиСоставаКИ.Вставить("ОсновноеКонтактноеЛицо");
	НастройкиСоставаКИ.Вставить("ПрочиеКонтактныеЛица");
	НастройкиСоставаКИ.Вставить("ОтветственныйМенеджер");
	
	Выборка = УправлениеНебольшойФирмойСервер.ПолучитьДоступныеДляПечатиВидыКИ().Выбрать();
	
	ИспользуемыеВидыКИ = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("УправлениеСоставомКонтактнойИнформацииКонтрагента",
	"ИспользуемыеВидыКИ", Новый Соответствие);
	
	Пока Выборка.Следующий() Цикл
		
		ИспользованиеКИ = ИспользуемыеВидыКИ.Получить(Выборка.ВидКИ);
		
		// Если доступного вида контактной информации нет в сохраненных настройках пользователя то установим использование по умолчанию
		Если ИспользованиеКИ = Неопределено Тогда
			ИспользованиеКИ = УправлениеНебольшойФирмойСервер.УстановитьПечатьВидаКИПоУмолчанию(Выборка.ВидКИ);
		КонецЕсли;
		
		Если ИспользованиеКИ Тогда
			НастройкиСоставаКИ.ИспользуемыеВидыКИ.Добавить(Выборка.ВидКИ);
			Если Выборка.ВидКИ.Родитель = Справочники.ВидыКонтактнойИнформации.СправочникКонтрагенты Тогда
				НастройкиСоставаКИ.ИспользуемыеВидыКИ_Контрагентов.Добавить(Выборка.ВидКИ);
			ИначеЕсли Выборка.ВидКИ.Родитель = Справочники.ВидыКонтактнойИнформации.СправочникКонтактныеЛица Тогда
				НастройкиСоставаКИ.ИспользуемыеВидыКИ_КонтактныхЛиц.Добавить(Выборка.ВидКИ);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	НастройкиСоставаКИ.КонтрагентИНН = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("УправлениеСоставомКонтактнойИнформацииКонтрагента",
		"КонтрагентИНН", Истина);
		
	НастройкиСоставаКИ.ОсновноеКонтактноеЛицо = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("УправлениеСоставомКонтактнойИнформацииКонтрагента",
		"ОсновноеКонтактноеЛицо", Истина);
		
	НастройкиСоставаКИ.ПрочиеКонтактныеЛица = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("УправлениеСоставомКонтактнойИнформацииКонтрагента",
		"ПрочиеКонтактныеЛица", Истина);
		
	НастройкиСоставаКИ.ОтветственныйМенеджер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("УправлениеСоставомКонтактнойИнформацииКонтрагента",
		"ОтветственныйМенеджер", Истина);
		
	Возврат НастройкиСоставаКИ;
		
КонецФункции

// Функция возвращает структуру областей макета для формирования контактной информации
//
&НаСервереБезКонтекста
Функция ЗаполнитьСтруктуруОбластейМакета(ВариантПечати)
	
	СтруктураОбластей = Новый Структура;
	
	Если ВариантПечати = "Карточка" Тогда
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Контрагенты.ПФ_MXL_КонтактнаяИнформацияКарточка");
		
		ОтступСПодчеркиванием = Макет.ПолучитьОбласть("Отступ");
		Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.РедкийПунктир, 3);
		Область = ОтступСПодчеркиванием.Область(1,1,ОтступСПодчеркиванием.ВысотаТаблицы, ОтступСПодчеркиванием.ШиринаТаблицы);
		Область.ЦветРамки = ЦветаСтиля.ЦветРамки;
		Область.Обвести(,,,Линия);
		
		СтруктураОбластей.Вставить("ОтступСПодчеркиванием",	  ОтступСПодчеркиванием);
		СтруктураОбластей.Вставить("Отступ",				  Макет.ПолучитьОбласть("Отступ"));
		СтруктураОбластей.Вставить("КонтрагентПредставление", Макет.ПолучитьОбласть("КонтрагентПредставление"));
		СтруктураОбластей.Вставить("КонтрагентДанные",		  Макет.ПолучитьОбласть("КонтрагентДанные"));
		СтруктураОбластей.Вставить("КонтрагентВидКИ",	  	  Макет.ПолучитьОбласть("КонтрагентВидКИ"));
		СтруктураОбластей.Вставить("КонтрагентЗначениеКИ",	  Макет.ПолучитьОбласть("КонтрагентЗначениеКИ"));
		СтруктураОбластей.Вставить("КонтактныеЛицаЗаголовок", Макет.ПолучитьОбласть("КонтактныеЛицаЗаголовок"));
		СтруктураОбластей.Вставить("КонтактноеЛицо", 		  Макет.ПолучитьОбласть("КонтактноеЛицо"));
		СтруктураОбластей.Вставить("КонтактноеЛицоКИ", 		  Макет.ПолучитьОбласть("КонтактноеЛицоКИ"));
		СтруктураОбластей.Вставить("ОтступКЛ", 		  		  Макет.ПолучитьОбласть("ОтступКЛ"));
		СтруктураОбластей.Вставить("Ответственный",			  Макет.ПолучитьОбласть("Ответственный"));
		
	ИначеЕсли ВариантПечати = "Список" Тогда
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Контрагенты.ПФ_MXL_КонтактнаяИнформацияСписок");
	
		СтруктураОбластей.Вставить("КонтрагентЗаголовок", 		  Макет.ПолучитьОбласть("КонтрагентЗаголовок"));
		СтруктураОбластей.Вставить("ВидКИЗаголовок",	  		  Макет.ПолучитьОбласть("ВидКИЗаголовок"));
		СтруктураОбластей.Вставить("КонтактноеЛицоЗаголовок", 	  Макет.ПолучитьОбласть("КонтактноеЛицоЗаголовок"));
		СтруктураОбластей.Вставить("ОтветственныйЗаголовок", 	  Макет.ПолучитьОбласть("ОтветственныйЗаголовок"));
		СтруктураОбластей.Вставить("КонтрагентДанные",	  		  Макет.ПолучитьОбласть("КонтрагентДанные"));
		СтруктураОбластей.Вставить("КИДанные", 			  		  Макет.ПолучитьОбласть("КИДанные"));
		СтруктураОбластей.Вставить("КонтактноеЛицоПредставление", Макет.ПолучитьОбласть("КонтактноеЛицоПредставление"));
		СтруктураОбластей.Вставить("КонтактноеЛицоЗначениеКИ", 	  Макет.ПолучитьОбласть("КонтактноеЛицоЗначениеКИ"));
		СтруктураОбластей.Вставить("ОтветственныйДанные", 		  Макет.ПолучитьОбласть("ОтветственныйДанные"));
		СтруктураОбластей.Вставить("Отступ",			  		  Макет.ПолучитьОбласть("Отступ"));
		
	КонецЕсли;
	                                                                           
	Возврат СтруктураОбластей;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыИФункцииСохраненияИОтправки

&НаСервере
Функция ПоместитьТабличныеДокументыВоВременноеХранилище(НастройкиСохранения)
	Перем ЗаписьZipФайла, ИмяАрхива;
	
	Результат = Новый Массив;
	
	// подготовка архива
	Если НастройкиСохранения.УпаковатьВАрхив Тогда
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ЗаписьZipФайла = Новый ЗаписьZipФайла(ИмяАрхива);
	КонецЕсли;
	
	// подготовка временной папки
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ИспользованныеИменаФайлов = Новый Соответствие;
	
	ВыбранныеФорматыСохранения = НастройкиСохранения.ФорматыСохранения;
	ТаблицаФорматов = УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента();
	
	// сохранение печатных форм
	ПечатнаяФорма = ТабДок;
	
	Если ПечатнаяФорма.ВысотаТаблицы = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого ТипФайла Из ВыбранныеФорматыСохранения Цикл
		НастройкиФормата = ТаблицаФорматов.НайтиСтроки(Новый Структура("ТипФайлаТабличногоДокумента", ТипФайлаТабличногоДокумента[ТипФайла]))[0];
		
		ИмяФайла = ПолучитьИмяВременногоФайлаДляПечатнойФормы("Контактная информация (" + ВариантПечати + ")", НастройкиФормата.Расширение, ИспользованныеИменаФайлов);
		ПолноеИмяФайла = УникальноеИмяФайла(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + ИмяФайла);
		
		ПечатнаяФорма.Записать(ПолноеИмяФайла, ТипФайла);
		
		Если ТипФайла = ТипФайлаТабличногоДокумента.HTML Тогда
			ВставитьКартинкиВHTML(ПолноеИмяФайла);
		КонецЕсли;
		
		Если ЗаписьZipФайла <> Неопределено Тогда
			ЗаписьZipФайла.Добавить(ПолноеИмяФайла);
		Иначе
			ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
			ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
			ОписаниеФайла = Новый Структура;
			ОписаниеФайла.Вставить("Представление", ИмяФайла);
			ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
			Если ТипФайла = ТипФайлаТабличногоДокумента.ANSITXT Тогда
				ОписаниеФайла.Вставить("Кодировка", "windows-1251");
			КонецЕсли;
			Результат.Добавить(ОписаниеФайла);
		КонецЕсли;
	КонецЦикла;
	
	// если архив подготовлен, записываем и помещаем его во временное хранилище
	Если ЗаписьZipФайла <> Неопределено Тогда
		ЗаписьZipФайла.Записать();
		ФайлАрхива = Новый Файл(ИмяАрхива);
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяАрхива);
		ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
		ОписаниеФайла = Новый Структура;
		ОписаниеФайла.Вставить("Представление", "Контактная информация " + "(" + ВариантПечати + ")" + ".zip");
		ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
		Результат.Добавить(ОписаниеФайла);
		
		УдалитьФайлы(ИмяАрхива);
	КонецЕсли;
	
	УдалитьФайлы(ИмяВременнойПапки);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьИмяВременногоФайлаДляПечатнойФормы(ИмяМакета, Расширение, ИспользованныеИменаФайлов)
	
	ШаблонИмениФайла = "%1%2.%3";
	
	ИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениФайла, ИмяМакета, "", Расширение));
		
	НомерИспользования = ?(ИспользованныеИменаФайлов[ИмяВременногоФайла] <> Неопределено,
							ИспользованныеИменаФайлов[ИмяВременногоФайла] + 1,
							1);
	
	ИспользованныеИменаФайлов.Вставить(ИмяВременногоФайла, НомерИспользования);
	
	// если имя уже было ранее использовано, прибавляем счетчик в конце имени
	Если НомерИспользования > 1 Тогда
		ИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонИмениФайла,
				ИмяМакета,
				" (" + НомерИспользования + ")",
				Расширение));
	КонецЕсли;
	
	Возврат ИмяВременногоФайла;
	
КонецФункции

&НаСервере
Процедура ВставитьКартинкиВHTML(ИмяФайлаHTML)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	ТекстHTML = ТекстовыйДокумент.ПолучитьТекст();
	
	ФайлHTML = Новый Файл(ИмяФайлаHTML);
	
	ИмяПапкиКартинок = ФайлHTML.ИмяБезРасширения + "_files";
	ПутьКПапкеКартинок = СтрЗаменить(ФайлHTML.ПолноеИмя, ФайлHTML.Имя, ИмяПапкиКартинок);
	
	// ожидается, что в папке будут только картинки
	ФайлыКартинок = НайтиФайлы(ПутьКПапкеКартинок, "*");
	
	Для Каждого ФайлКартинки Из ФайлыКартинок Цикл
		КартинкаТекстом = Base64Строка(Новый ДвоичныеДанные(ФайлКартинки.ПолноеИмя));
		КартинкаТекстом = "data:image/" + Сред(ФайлКартинки.Расширение,2) + ";base64," + Символы.ПС + КартинкаТекстом;
		
		ТекстHTML = СтрЗаменить(ТекстHTML, ИмяПапкиКартинок + "\" + ФайлКартинки.Имя, КартинкаТекстом);
	КонецЦикла;
		
	ТекстовыйДокумент.УстановитьТекст(ТекстHTML);
	ТекстовыйДокумент.Записать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПечатныеФормыВПапку(СписокФайловВоВременномХранилище, Знач Папка = "")
	
	#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
		Для Каждого ФайлДляЗаписи Из СписокФайловВоВременномХранилище Цикл
			ПолучитьФайл(ФайлДляЗаписи.АдресВоВременномХранилище, ФайлДляЗаписи.Представление);
		КонецЦикла;
		Возврат;
	#КонецЕсли
	
	Папка = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Папка);
	Для Каждого ФайлДляЗаписи Из СписокФайловВоВременномХранилище Цикл
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ФайлДляЗаписи.АдресВоВременномХранилище);
		ДвоичныеДанные.Записать(УникальноеИмяФайла(Папка + ФайлДляЗаписи.Представление));
	КонецЦикла;
	
	Состояние(НСтр("ru = 'Сохранение успешно завершено'"), , НСтр("ru = 'в папку:'") + " " + Папка);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УникальноеИмяФайла(ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	ИмяБезРасширения = Файл.ИмяБезРасширения;
	Расширение = Файл.Расширение;
	Папка = Файл.Путь;
	
	Счетчик = 1;
	Пока Файл.Существует() Цикл
		Счетчик = Счетчик + 1;
		Файл = Новый Файл(Папка + ИмяБезРасширения + " (" + Счетчик + ")" + Расширение);
	КонецЦикла;
	
	Возврат Файл.ПолноеИмя;
	
КонецФункции

#КонецОбласти